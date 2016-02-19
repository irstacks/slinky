# Description
#   Custom giffers.
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot grab me (miyagi|what) - grab miyagi, or what???
#   hubot pomp pomp - crazy muthafuckin awesome kid
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Mr. Is <isaac.ardis@gmail.com>

module.exports = (robot) ->

  robot.respond /grab me (.*)/i, (res) ->
    wants = res.match[1]
    res.send "http://areteh.co/rodeo/miyagi.gif" if wants == "miyagi"
    res.send "http://areteh.co/rodeo/what.gif" if wants == "what"

  robot.respond /pomp pomp/i, (res) ->
    res.send "http://areteh.co/rodeo/who-is-that-kid-hes-awesome.gif"
