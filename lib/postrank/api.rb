require 'em-synchrony'
require 'chronic'
require 'json'
require 'yajl'

module PostRank
  class API

    def initialize(opts)
      @appkey = opts[:appkey]
      @parser = Yajl::Parser.new
    end

    def feed_info(opts)
      req = {
        :query => {
          :appkey => @appkey,
          :noidex => opts[:noindex] || false,
        },
        :body => [opts[:feed]].flatten.map{|e| "feed[]=#{e}"}.join("&")
      }

      http = EM::HttpRequest.new('http://api.postrank.com/v2/feed/info').post(req)
      resp = parse(http.response)

      resp.key?('items') ? resp['items'] : resp
    end

    def feed(opts)
      req = {
        :query => {
          :appkey => @appkey,
          :level  => opts[:level] || 'all',
          :q      => opts[:q]     || '',
          :num    => opts[:num]   || 10,
          :start  => opts[:start] || 0,
          :id     => opts[:feed]
        }
      }

      http = EM::HttpRequest.new('http://api.postrank.com/v2/feed/').get(req)
      parse(http.response)
    end

    def top_posts(opts)
      req = {
        :query => {
          :appkey => @appkey,
          :q      => opts[:q]     || '',
          :num    => opts[:num]   || 10,
          :id     => opts[:feed]
        }
      }

      http = EM::HttpRequest.new('http://api.postrank.com/v2/feed/topposts/').get(req)
      parse(http.response)
    end

    def feed_engagement(opts)
      opts[:start_time] ||= '1 month ago'
      opts[:end_time]   ||= 'today'
      opts[:summary]    = true if not opts.key?(:summary)

      req = {
        :query => {
          :appkey     => @appkey,
          :mode       => opts[:mode] || 'daily',
          :start_time => Chronic.parse(opts[:start_time]).to_i,
          :end_time => Chronic.parse(opts[:end_time]).to_i
        },
        :body => [opts[:feed]].flatten.map{|e| "feed[]=#{e}"}.join("&")
      }

      # TODO: fix in the API.. summary=false should not do summary!
      req[:query][:summary] = opts[:summary] if opts[:summary]

      http = EM::HttpRequest.new('http://api.postrank.com/v2/feed/engagement').post(req)
      resp = parse(http.response)
    end

    private

      def parse(data)
        begin
          JSON.parse(data)
          # @parser.parse(data)
        rescue Exception => e
          puts "Failed to parse request:"
          puts e.message
          puts e.backtrace[0,5].join("\n")

        end
      end

  end
end
