# Description:
#   Create and search for tweets on Twitter.
#
# Dependencies:
#   "twit": "1.1.x"
#
# Configuration:
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_ACCESS_TOKEN
#   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
#
# Commands:
#   hubot twitter <command> <query> - Search Twitter for a query
#
# Author:
#   gkoo
#

Twit = require 'twit'

config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

twit = undefined

getTwit = ->
  unless twit
    twit = new Twit config
  return twit

whatWouldTophTweet = (msg) ->
  username = 'tophtucker' #msg.match[2]

  twit = getTwit()
  count = 300
  searchConfig =
    screen_name: username,
    count: count

  twit.get 'statuses/user_timeline', searchConfig, (err, statuses) ->
    return msg.send "Error retrieving tweets!" if err
    return msg.send "No results returned!" unless statuses?.length

    # get tweet that is not talking directly to someone or RT-ing
    random_tweet = ""
    random_index = 0
    pattern = /^(\@|RT)/i # text begins with @

    getARandomTophTweet = ->
      random_index = Math.floor(Math.random() * statuses.length)
      random_tweet = statuses[random_index]

    # if at first you don't succeed...
    getARandomTophTweet()

    # try try again
    while random_tweet.text.match pattern
      if random_tweet.text.match pattern
        getARandomTophTweet()
      else
        break

    return msg.send "Number #{random_index} from Toph's last #{count} tweets ->\n#{random_tweet.text}"

module.exports = (robot) ->

  # What would toph tweet.
  robot.hear /wwtt\?/i, (msg) ->
    whatWouldTophTweet(msg)
