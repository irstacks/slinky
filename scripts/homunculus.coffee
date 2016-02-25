# Description:
#   Set inhibitions for hubot.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   Mr. Is

Inhibitions = (pep, importanceBias) ->
  peppiness_level = parseFloat(pep)
  calculated_pep = peppiness_level/100.0*importanceBias
  rand = Math.random()
  if rand < calculated_pep # ie 50/100 * .8
    # console.log "Chances were " + rand + "would be < " + calculated_pep
    return true
  else
    return false

module.exports = Inhibitions
