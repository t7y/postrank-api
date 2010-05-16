require 'spec'
require 'lib/postrank/api'
require 'pp'

describe PostRank::API do

  let(:api) { PostRank::API.new(:appkey => 'test') }

  it "should initialize with appkey" do
    lambda {
      PostRank::API.new(:appkey => 'test')
    }.should_not raise_error
  end

  describe "FeedInfo API" do
    it "should query for feed info" do
      EM.synchrony do
        igvita = api.feed_info(:feed => 'igvita.com')

        igvita.class.should == Hash
        igvita['tags'].class.should == Array
        igvita['xml'].should match(/igvita/)

        EM.stop
      end
    end

    it "should query for feed info for multiple feeds" do
      EM.synchrony do
        feeds = api.feed_info(:feed => ['igvita.com', 'everburning.com'])
        feeds.class.should == Array
        feeds.size.should == 2

        EM.stop
      end
    end

    it "should return feed info data in-order"
  end

  describe "Feed API" do
    it "should retrieve content of a feed" do
      EM.synchrony do
        igvita = api.feed_info(:feed => 'igvita.com')
        feed = api.feed(:feed => igvita['id'])

        feed.class.should == Hash
        feed['meta']['title'].should match(/igvita/)
        feed['items'].size.should == 10

        EM.stop
      end
    end
  end
end
