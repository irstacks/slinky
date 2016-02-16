
module.exports = (robot) ->
  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      message.user.name is "yaya" and Math.random() > 0.8
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.reply "YAYA! YOU'RE MY BEST FRIEND!"
  )

  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      message.user.name is "therealia" and Math.random() > 0.8
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.send "Yea! What he said!"
  )

  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      message.user.name is "james" and Math.random() > 0.8
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.send "Nice."
  )

  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      message.user.name is "iiabney" and Math.random() > 0.8
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.send "Ooooooooooohhhhhhhhhh!"
  )

  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      message.length > 140 and Math.random() > 0.8
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.send "Feeling loquacious, eh?"
  )

  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      Math.random() > 0.97
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.reply response.random ["My friend, you're out of your mind.", "No. Whatever that means, I'm against it.\nThat's just how I feel.", "It's a trap!", "Bitch, please."]
  )
