

module.exports = (robot) ->

  # Turning slinky up or down.

  # Go.
  robot.respond /(go)$/i, (res) ->
    robot.brain.set 'pep', 100
    res.send "Got it. Pep set to 100."

  # Slow.
  robot.respond /(slow)$/i, (res) ->
    robot.brain.set 'pep', 30
    res.send "Got it. Pep set to 30."

  # Stop.
  robot.respond /(stop)$/i, (res) ->
    robot.brain.set 'pep', 0
    res.send "Got it. Pep set to 0."

  # Precision pep.
  # [1,2,3,4,5]
  # arr.length = 5
  # last el = arr[4]
  robot.respond /(^set\s)(pep(|py|piness))\s(\d+)$/i, (res) ->
    pep_lev = res.match[res.match.length-1] # the number is last match arg
    robot.brain.set 'pep', pep_lev
    res.send "Pep level set to #{pep_lev}."

  # Pep level turn down.
  robot.respond /pip(|e) down|quiet|(s|)hush|\bsh\b|less pep|pep (down|less)/i, (res) ->
    current_pep = robot.brain.get('pep')
    robot.brain.set 'pep', current_pep*0.6
    res.send "OK. Pep level turned down to #{current_pep*0.6}."

  # Turnt up to what.
  robot.respond /(pip(|e)|speak) up|be louder|ratchet|more pep|pep up|.*(beer|tequila)/i, (res) ->
    alcohol = res.match[-1]
    current_pep = robot.brain.get('pep')
    if alcohol == 'beer'
      robot.brain.set 'pep', current_pep*1.4
      res.send "Delicious. Current pep set to #{robot.brain.get('pep')}"
    if alcohol == 'tequila'
      robot.brain.set 'pep', current_pep*2
      res.send "Tequila! My favorite. Current pep set to #{robot.brain.get('pep')}"
    else
      robot.brain.set 'pep', current_pep*1.2
      res.send "OK. Current pep set to #{robot.brain.get('pep')}"

  # Manners and get pep levelers.
  robot.respond /(((what(|\'s)|where(|'s)|how)(are|is|)(your|)).+(manners|pep)|pep level|peppiness|^manners$)/i, (res) ->
    current_pep = robot.brain.get('pep')
    res.send "Pep level set to #{current_pep}."

  # General borkenness computer.
  # By the way this script is loaded first because of the alphabet.
  # This is the last time I write a useless comment to test a git hook.
  # Almost the last time.
  # Come on.
  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"



