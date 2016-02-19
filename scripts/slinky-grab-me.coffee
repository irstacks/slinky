# Dese be hosted custom by us. Can add whatever here.

module.exports = (robot) ->

  robot.respond /grab me (.*)/i, (res) ->
    wants = res.match[1]
    if wants == 'miyagi'
      res.send "http://areteh.co/rodeo/miyagi.gif"
    if wants == 'what'
      res.send "http://areteh.co/rodeo/what.gif"

  robot.respond /pomp pomp/i (res) ->
    res.send "http://areteh.co/rodeo/who-is-that-kid-hes-awesome.gif"
