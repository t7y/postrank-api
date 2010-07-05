require 'spec'
require 'lib/postrank-api'
require 'pp'

describe PostRank::API do
  IGVITA = '421df2d86ab95100de7dcc2e247a08ab'
  EVERBURNING = 'cb3e81ac96fb0ada1212dfce4f329474'
  let(:api) { PostRank::API.new('test') }

  it "should initialize with appkey" do
    lambda {
      PostRank::API.new('test')
    }.should_not raise_error
  end

  describe "FeedInfo API" do
    it "should query for feed info" do
      igvita = api.feed_info('igvita.com')

      igvita.class.should == Hash
      igvita['tags'].class.should == Array
      igvita['xml'].should match(/igvita/)
    end

    it "should query for feed info for multiple feeds" do
      feeds = api.feed_info(['igvita.com', 'everburning.com'])
      feeds.class.should == Array
      feeds.size.should == 2
    end

    it "should return feed info data in-order" do
      feeds = api.feed_info(['igvita.com', 'everburning.com'])
      feeds.class.should == Array
      feeds.first['xml'].should match('igvita.com')
    end
  end

  describe "Feed API" do
    it "should retrieve content of a feed" do
      igvita = api.feed_info('igvita.com')
      feed = api.feed(igvita['id'])

      feed.class.should == Hash
      feed['meta']['title'].should match(/igvita/)
      feed['items'].size.should == 10
    end

    it "should retrieve 1 entry from a feed" do
      EM.synchrony do
        feed = api.feed(IGVITA, :num => 1)

        feed.class.should == Hash
        feed['meta']['title'].should match(/igvita/)
        feed['items'].size.should == 1

        EM.stop
      end
    end

    it "should retrieve entries matching a query" do
      EM.synchrony do
        feed = api.feed(IGVITA, :q => 'abrakadabra')

        feed.class.should == Hash
        feed['meta']['title'].should match(/igvita/)
        feed['items'].size.should == 0

        EM.stop
      end
    end
  end

  describe "Recommendations API" do

    it "should fetch recommendations for a single feed" do
       EM.synchrony do
          resp = api.recommendations(IGVITA)
            resp.class.should == Array
          EM.stop
        end
      end

    it "should fetch recommendation for a set of feeds" do
     EM.synchrony do
        resp = api.recommendations([IGVITA, EVERBURNING], :num => 1)

          resp.class.should == Array
          resp.size.should == 1

        EM.stop
      end
    end
  end

  describe "Top Posts API" do
    it "should fetch top posts for a feed" do
      EM.synchrony do
        feed = api.top_posts(IGVITA, :num => 1)

        feed.class.should == Hash
        feed['meta']['title'].should match(/igvita/)
        feed['items'].size.should == 1

        EM.stop
      end
    end
  end

 describe "Metrics Versioned API" do
    it "should fetch metrics for a single post" do
      EM.synchrony do
        met = api.metrics_versioned('b0432f947bc0d44766d046bfc3c15043', {:start_time => '5 years ago', :end_time => 'today'})
        met.class.should == Hash
        met.keys.size.should == 1
        EM.stop
      end
    end
    it "should fetch metrics for multiple posts" do
      EM.synchrony do
        met = api.metrics_versioned(['b0432f947bc0d44766d046bfc3c15043', 'a020c1c3a5b2aef1ab4a7307cf3d2cb6'], {:start_time => '5 years ago', :end_time => 'today'})
        met.class.should == Hash
        met.keys.size.should == 2
        EM.stop
      end
    end
  end

  describe "Postrank API" do
    it "should fetch postrank with respect to provided urls" do
      EM.synchrony do
          pr = api.postrank(['http://www.igvita.com/2008/06/19/splunk-your-distributed-logs-in-ec2/', 'http://www.igvita.com/2008/02/11/nginx-and-memcached-a-400-boost/'])
          pr.class.should == Hash
          pr.keys.size.should == 2
        EM.stop
       end
    end
    it "should fetch postrank with respect specific feeds" do
      EM.synchrony do
        pr = api.postrank(['http://www.igvita.com/2008/06/19/splunk-your-distributed-logs-in-ec2/', 'http://www.igvita.com/2008/02/11/nginx-and-memcached-a-400-boost/'], ['421df2d86ab95100de7dcc2e247a08ab'])
        pr.class.should == Hash
        pr.keys.size.should == 2
       EM.stop
      end
    end
  end

  describe "Feed Engagement API" do
    it "should fetch engagement for a feed" do
      EM.synchrony do
        eng = api.feed_engagement(IGVITA)

        eng.class.should == Hash
        eng.keys.size.should == 1
        eng[IGVITA]['sum'].class.should == Float

        EM.stop
      end
    end

    it "should fetch daily engagement for multiple feeds" do
      EM.synchrony do
        eng = api.feed_engagement([IGVITA, EVERBURNING], {
                                    :summary => false,
                                    :start_time => 'yesterday',
                                    :end_time => 'today'
        })

        eng.class.should == Hash
        eng.keys.size.should == 2
        eng[IGVITA].keys.size.should == 2

        EM.stop
      end
    end
  end

  describe "Metrics API" do
    it "should fetch metrics for a collection of urls" do
      EM.synchrony do
        metrics = api.metrics(['http://www.igvita.com/', 'http://www.everburning.com/'])
        metrics.keys.size.should == 2

        metrics['http://www.igvita.com/'].class.should == Hash
        metrics['http://www.everburning.com/'].class.should == Hash

        EM.stop
      end
    end

    it "should fetch metrics via url md5s" do
      EM.synchrony do
        metrics = api.metrics('1c1a5357e8bd00128db845b2595d5ebe')

        metrics.keys.size.should == 1
        metrics['1c1a5357e8bd00128db845b2595d5ebe'].class.should == Hash

        EM.stop
      end
    end
  end

  describe "Domain API" do
    it "should fetch metrics for a collection of domains" do
      EM.synchrony do
        activity = api.domain_activity('igvita.com')
        activity.keys.size.should == 1
        activity['igvita.com'].class.should == Hash

        EM.stop
      end
    end

    it "should fetch daily activity for multiple domains" do
      EM.synchrony do
        act = api.domain_activity(['igvita.com', 'techcrunch.com'], {
                                    :start_time => 'yesterday',
                                    :end_time => 'today'
        })

        act.class.should == Hash
        act.keys.size.should == 2

        EM.stop
      end
    end

  end

  it "should invoke and kill EM reactor transparently" do
    metrics = api.metrics('1c1a5357e8bd00128db845b2595d5ebe')
    metrics.keys.size.should == 1
    metrics['1c1a5357e8bd00128db845b2595d5ebe'].class.should == Hash
  end

end
