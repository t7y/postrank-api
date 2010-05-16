require 'em-synchrony'
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
