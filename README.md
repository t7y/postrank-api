# Ruby PostRank API

Prototype PR API wrapper - at the moment, async, depends on Ruby 1.9 Fibers & EventMachine.

## A few simple examples

    require "postrank-api"

    api = PostRank::API.new(:appkey => 'someuser')

    igvita = api.feed_info(:feed => 'igvita.com')
    feed   = api.feed(:feed => igvita['id'])
    top    = api.top_posts(:feed => igvita['id'], :num => 1)
    eng    = api.engagement(:feed => igvita['id'], :start => 'yesterday')

    metrics = api.metrics(:url => 'http://www.igvita.com/')

