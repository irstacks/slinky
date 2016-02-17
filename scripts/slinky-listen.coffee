# Is a heckler.
heckles = require './data/heckles.json'

module.exports = (robot) ->

  inhibitions = (importanceBias) ->
    peppiness_level = robot.brain.get('pep')
    calculated_pep = peppiness_level/100*importanceBias
    rand = Math.random()
    if rand < calculated_pep # ie 50/100 * .8
      # console.log "Chances were " + rand + "would be < " + calculated_pep
      return true
    else
      return false

  # Heckles teammates.
  # robot.listen(
  #   (message) -> # Match function
  #     # Occassionally respond to things that Steve says
  #     inhibitions(0.05)
  #   (response) -> # Standard listener callback
  #     # Let Steve know how happy you are that he exists
  #     response.send response.random heckles["#{response.user.name}"]
  # )
  robot.hear /.*/i, (res) ->
    if inhibitions(0.05)
      res.reply res.random heckles["#{res.message.user.name.toLowerCase()}"]

  # Heckles speechifying.
  # robot.listen(
  #   (message) -> # Match function
  #     # Occassionally respond to things that Steve says
  #     inhibitions(0.1) and message.message.text.length > 200
  #   (response) -> # Standard listener callback
  #     # Let Steve know how happy you are that he exists
  #     response.send response.random heckles.loquacious_people
  # )
  robot.hear /.*/i, (res) ->
    if res.message.text.length > 200 and inhibitions(0.1)
      res.send res.random heckles.loquacious_people

  # Heckles at liberty.
  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      inhibitions(0.03)
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.reply response.random heckles.willy_nilly
  )
  # robot.hear /.*/i, (res) ->
  #   if inhibitions(0.03)
  #     res.send res.random heckles.willy_nilly

