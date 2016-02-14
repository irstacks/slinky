# tophers = [
#   '31555931', #Homework...
#   '1931795771', #Pogue LED continuum
#   '4119156292', #Windows 8 start menu prescience
#   '7250133137', #rotating out of the aughts
#   '7111916773', #scarecrow's thoughtfulness
#   '6557934634', #@office @googlewave factchecker
#   '7810280394', #twitter outgoing lists
#   '7425684611', #creating gelato fiasco foursquare venue
#   '7266553623', ##10yearsago i was asleep
#   '9582322439', #pocket-tweet
#   '8787585042', #last year's super bowl
#   '11337955968', #introducing scoober to mailchimp lol
#   '11289192552', #implied trivalent predicate
#   '11289098252', #Things That Return No Google Results But Should #1 artificially augmented proprioception
#   '10965467296', #hygiene hypothesis
#   '10959424388', #we often say be yourself
#   '10663073432', #contract with creators of lost
#   '10660590984', #best thing we can do for the earth is get off of it
#   '10641145325', #twoosh novelty
#   '10498282576', #RIP Oveur, over
#   '10463525810', #whoah it's 5:20
#   '10357473750', #first geolocated tweet
#   '13095878920', #perfect enemy of good
#   '13095853833', #adjectives, adverbs, then what?
#   '13039741275', #five websites

#   # ok, pick up where you left off one day and keep curating:
#   # file:#localhost/Users/tophtucker/Dropbox/Archives/tweets/index.html#

#   '181191415148191744', # Practice makes better

#   '186581115753074688', # Apr 1 12: Island of misfit toys
#   '186581956404842496', # cont.
#   '186583662828060672',
#   '186584736444063744',
#   '186585214267572224',
#   '186585834584150016',

#   '186708960777216000', # Apr 1 12: anthropic doomsday principle
#   '186713150568153089' # Apr 1 12: go home and hug your children mode
# ]

# # Description:
# #   Display a random tweet from twitter about a subject
# #
# # Dependencies:
# #    "ntwitter" : "https://github.com/sebhildebrandt/ntwitter/tarball/master",
# #
# # Configuration:
# #   HUBOT_TWITTER_CONSUMER_KEY
# #   HUBOT_TWITTER_CONSUMER_SECRET
# #   HUBOT_TWITTER_ACCESS_TOKEN_KEY
# #   HUBOT_TWITTER_ACCESS_TOKEN_SECRET
# #
# # Commands:
# #   hubot <keyword> tweet - Returns a link to a tweet about <keyword>
# #
# # Notes:
# #   There's an outstanding issue on AvianFlu/ntwitter#110 for search and the v1.1 API.
# #   sebhildebrandt is a fork that is working, so we recommend that for now. This
# #   can be removed after the issue is fixed and a new release cut, along with updating the dependency
# #
# # Author:
# #   atmos, technicalpickles

# ntwitter = require 'ntwitter'
# inspect = require('util').inspect

# module.exports = (robot) ->
#   auth =
#     consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
#     consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
#     access_token_key: process.env.HUBOT_TWITTER_ACCESS_TOKEN_KEY
#     access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

#   twit = undefined

#   robot.respond /wwtt/i, (msg) ->
#     unless auth.consumer_key
#       msg.send "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
#       return
#     unless auth.consumer_secret
#       msg.send "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
#       return
#     unless auth.access_token_key
#       msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_KEY environment variable."
#       return
#     unless auth.access_token_secret
#       msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
#       return


#     twit ?= new ntwitter auth


#     twit.verifyCredentials (err, data) ->
#       if err
#         msg.send "Encountered a problem verifying twitter credentials :(", inspect err
#         return

#       q = escape(msg.match[1])
#       twit.search q, (err, data) ->
#         # twit.stream 'user', (err, data) ->
#       # rand = tophers[Math.floor(Math.random() * myArray.length)]

#       # urler = 'https://twitter.com/tophtucker/status/' + rand
#       # twit.get urler (err, data) ->
#       # twit.stream 'user', {track:'tophtucker', limit:1}, (err, data) ->
#         if err
#           msg.send "Encountered a problem twitter searching :(", inspect err
#           return

#         if data.statuses? and data.statuses.length > 0
#           status = msg.random data.statuses
#           msg.send "https://twitter.com/#{status.user.screen_name}/status/#{status.id_str}"
#         else
#           msg.reply "No one is tweeting about that."
