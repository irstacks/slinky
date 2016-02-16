# Is a heckler.
heckles = require './data/heckles.json'

module.exports = (robot) ->

  # Heckles teammates.
  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      sname = message.user.name
      message.user.name is sname and Math.random() > 0.92
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.send response.random heckles[sname]
  )

  # Heckles speechifying.
  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      message.length > 200 and Math.random() > 0.9
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.send response.random heckles.loquacious_people
  )

  # Heckles at liberty.
  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      Math.random() > 0.97
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.reply response.random heckles.willy_nilly
  )
