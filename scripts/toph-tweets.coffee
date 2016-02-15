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

# Twit = require 'twit'

# config =
#   consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
#   consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
#   access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN
#   access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

# twit = undefined

# getTwit = ->
#   unless twit
#     twit = new Twit config
#   return twit

# whatWouldTophTweet = (msg) ->
#   username = 'tophtucker' #msg.match[2]

#   twit = getTwit()
#   count = 50
#   searchConfig =
#     screen_name: username,
#     count: count

#   twit.get 'statuses/user_timeline', searchConfig, (err, statuses) ->
#     return msg.send "Error retrieving tweets!" if err
#     return msg.send "No results returned!" unless statuses?.length

#     randomTophTweet = statuses[Math.floor(Math.random() * myArray.length)]
#     response = "#{randomTophTweet.text}"
#     # i = 0
#     # msg.send "Recent tweets from #{statuses[0].user.screen_name}"
#     # for status, i in statuses
#     #   response += "#{status.text}"
#     #   response += "\n" if i != count-1

#     return msg.send response

# module.exports = (robot) ->

#   robot.hear /wwtt/i, (res) ->
#     whatWouldTophTweet()
