module.exports = (robot) ->

  robot.respond /grab me (.*)/i, (res) ->
    wants = res.match[1]
    res.send "http://areteh.co/rodeo/miyagi.gif" if wants == "miyagi"
    res.send "http://areteh.co/rodeo/what.gif" if wants == "what"

  robot.respond /pomp pomp/i, (res) ->
    res.send "http://areteh.co/rodeo/who-is-that-kid-hes-awesome.gif"
