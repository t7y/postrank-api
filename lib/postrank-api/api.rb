require 'em-synchrony'
require 'em-synchrony/em-http'

require 'digest/md5'
require 'chronic'
require 'yajl'

module PostRank
  class API
    V2_API_BASE = 'http://api.postrank.com/v2'

    def initialize(appkey)
      @appkey = appkey
    end

    def feed_info(feeds, opts = {})
      req = {
        :query => {
          :appkey => @appkey,
          :noindex => opts[:noindex] || false,
        },
        :body => build_body(feeds, 'feed')
      }

      http = post("#{V2_API_BASE}/feed/info", req)
      resp = parse(http.response)

      resp.key?('items') ? resp['items'] : resp
    end

    def feed(feed, opts = {})
      req = {
        :query => {
          :appkey => @appkey,
          :level  => opts[:level] || 'all',
          :q      => opts[:q]     || '',
          :num    => opts[:num]   || 10,
          :start  => opts[:start] || 0,
          :id     => feed
        }
      }

      http = get("#{V2_API_BASE}/feed/", req)
      parse(http.response)
    end

    def top_posts(feed, opts = {})
      req = {
        :query => {
          :appkey => @appkey,
          :q      => opts[:q]     || '',
          :num    => opts[:num]   || 10,
          :id     => feed
        }
      }

      http = get("#{V2_API_BASE}/feed/topposts/", req)
      parse(http.response)
    end

    def feed_engagement(feeds, opts = {})
      opts[:start_time] ||= '1 month ago'
      opts[:end_time]   ||= 'today'
      opts[:summary]    = true if not opts.key?(:summary)

      req = {
        :query => {
          :appkey     => @appkey,
          :mode       => opts[:mode] || 'daily',
          :start_time => Chronic.parse(opts[:start_time]).to_i,
          :end_time   => Chronic.parse(opts[:end_time]).to_i
        },
        :body => build_body(feeds, 'feed')
      }

      req[:query][:summary] = opts[:summary] if opts[:summary]

      http = post("#{V2_API_BASE}/feed/engagement", req)
      parse(http.response)
    end

    def metrics(urls, opts = {})
      reverse = {}
      urls = [urls].flatten.map do |url|
        md5 = (url =~ /\w{32}/) ? url : Digest::MD5.hexdigest(url)
        reverse[md5] = url
        md5
      end

      req = {
        :query => {
          :appkey => @appkey,
        },
        :body => build_body(urls, 'url')
      }

      http = post("#{V2_API_BASE}/entry/metrics", req)
      parse(http.response).inject({}) do |hash, v|
        hash[reverse[v[0]]] = v[1]
        hash
      end
    end

    private

      def parse(data)
        begin
          Yajl::Parser.parse(data)
        rescue Exception => e
          puts "Failed to parse request:"
          puts e.message
          puts e.backtrace[0, 5].join("\n")
        end
      end

      def build_body(urls, key)
        [urls].flatten.map { |e| "#{key}[]=#{e}" }.join("&")
      end

      def post(url, req)
        dispatch(:post, url, req)
      end

      def get(url, req)
        dispatch(:get, url, req)
      end

      def dispatch(method, url, req)
        if EM.reactor_running?
          http = EM::HttpRequest.new(url).send(method, req)
        else
          EM.synchrony do
            http = EM::HttpRequest.new(url).send(method, req)
            EM.stop
          end
        end
        http
      end
  end
end
