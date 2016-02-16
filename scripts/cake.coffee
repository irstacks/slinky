module.exports = (robot) ->

  # General borkenness computer.
  # By the way this script is loaded first because of the alphabet.
  # This is the last time I write a useless comment to test a git hook.
  # Almost the last time.
  # Come on.
  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"



