# Ruby PostRank API Wrapper

PostRank API wrapper for Ruby 1.9.

 * EventMachine & Fibers under the hood - async friendly.
 * Can be used outside of an EM loop - wrapper will spin up and shut down the reactor on demand.

For complete documentation on all endpoints please see [PostRank API Docs](http://apidocs.postrank.com)

## A few simple examples

    require "postrank-api"

    api = PostRank::API.new('my-appkey')

    # map a site to postrank id's + retrieve feed meta data
    igvita = api.feed_info('igvita.com')

    # grab the latest stories from igvita.com
    feed   = api.feed(igvita['id'])

    # grab the top recent post from igvita.com
    top    = api.top_posts(igvita['id'], :num => 1)

    # lookup the engagement score for the past two days
    eng    = api.engagement(igvita['id'], :start => 'yesterday')

    # lookup social metrics for a url
    metrics = api.metrics('http://www.igvita.com/')

    # get recommended feeds
    recommendations = api.recommendations(igvita['id'])

    #lookup relative postranks for given posts
    postrank = api.postrank(top['items'].collect!{|info| info['original_link']})

    #lookup metrics history for a given post hash
    history = api.postrank(top['items'].first['id'], :start => '1 month ago')