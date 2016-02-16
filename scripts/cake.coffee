module.exports = (robot) ->

  # General borkenness computer.
  # By the way this script is loaded first because of the alphabet.
  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"



