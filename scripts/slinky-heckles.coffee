# Is a heckler.
Inhibitions = require './homunculus.coffee'
heckles = require './data/heckles.json'

module.exports = (robot) ->

  pep = robot.brain.get('pep')

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
    if Inhibitions(pep, 0.1)
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
    if res.message.text.length > 200 and Inhibitions(pep, 0.3)
      res.send res.random heckles.loquacious_people

  # Heckles at liberty.
  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      Inhibitions(pep, 0.05)
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.reply response.random heckles.willy_nilly
  )
  # robot.hear /.*/i, (res) ->
  #   if inhibitions(0.03)
  #     res.send res.random heckles.willy_nilly

