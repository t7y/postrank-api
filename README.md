# Ruby PostRank API

Prototype PR API wrapper - at the moment, async, depends on Ruby 1.9 Fibers & EventMachine.

## A few simple examples

    require "postrank-api"

    api = PostRank::API.new('my-appkey')

    igvita = api.feed_info('igvita.com')
    feed   = api.feed(igvita['id'])
    top    = api.top_posts(igvita['id'], :num => 1)
    eng    = api.engagement(igvita['id'], :start => 'yesterday')

    metrics = api.metrics('http://www.igvita.com/')

