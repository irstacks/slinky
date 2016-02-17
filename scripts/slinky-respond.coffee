feelings = require './data/feelings.json'

module.exports = (robot) ->

  # Is slow.
  robot.respond /you are a little slow|you're a little slow/i, (res) ->
    setTimeout () ->
      res.send "Who you calling 'slow'?"
    , 60 * 1000

  # Likes random numbers.
  robot.respond /did I win the lottery (\d.\d+)/i, (res) ->
    sponder = ""
    pretend_importance_level = parseFloat(res.match[1])
    sponder += "pretend_importance_level: #{pretend_importance_level}\n"
    peppiness_level = robot.brain.get('pep')
    sponder += "peppiness_level: #{peppiness_level}\n"
    peppiness_level_float = parseFloat(peppiness_level)
    sponder += "peppiness_level_float: #{peppiness_level_float}\n"
    percent_calculated_pep = peppiness_level_float/100.00
    sponder += "percent_calculated_pep: #{percent_calculated_pep}\n"
    calc_pep = percent_calculated_pep*pretend_importance_level
    sponder += "calc_pep: #{calc_pep}\n"
    rand = Math.random()
    sponder += "rand: #{rand}"
    res.send sponder

  # Is clever.
  # Rememberer.
  robot.respond /remember+( that)?( the)? (.*) (is|are|as|equals) (.*)/i, (res) ->
    # Get number of sodas had (coerced to a number).
    # sodasHad = robot.brain.get('totalSodas') * 1 or 0
    thing_to_remember_as = res.match[3]
    thing_to_remember = res.match[5]
    # if the thing is a new thing
    if robot.brain.get(thing_to_remember_as) == null
      # res.reply "I'm too fizzy.."
      robot.brain.set thing_to_remember_as, thing_to_remember
      res.reply "OK, I have #{thing_to_remember_as} down as #{thing_to_remember}.\nCarry on."
    else
      res.reply "OK, but be advised: #{thing_to_remember_as} used to be #{robot.brain.get(thing_to_remember_as)}"
      res.send "Updating..."
      robot.brain.set thing_to_remember_as, thing_to_remember
      res.send "Got it. #{thing_to_remember_as} is #{thing_to_remember}"

    # else
      # res.reply "Well, I already got #{thing_to_remember_as} remembered as #{thing_to_remember}."

  # Remembering.
  robot.respond /what (is|are)+( the)? (.*)/i, (res) ->
    thing_to_be_remembered = res.match[3]
    thing = robot.brain.get(thing_to_be_remembered)
    res.send "#{thing}"


  # Riddlers.
  robot.respond /play with me/i, (msg) ->
    url = "riddles"
    msg.http("http://www.reddit.com/r/#{url}.json")
    .get() (err, res, body) ->
      try
        data = JSON.parse body
        children = data.data.children
        joke = msg.random(children).data

        joketext = joke.title.replace(/\*\.\.\.$/,'') + ' ' + joke.selftext.replace(/^\.\.\.\s*/, '')

        msg.send "Alright. It goes like this:\n" + joketext.trim()

      catch ex
        msg.send "Erm, something went EXTREMELY wrong - #{ex}"

  # Jokers.
  robot.respond /.+(joke|jokes|funny)/i, (msg) ->
    url = "jokes"
    msg.http("http://www.reddit.com/r/#{url}.json")
    .get() (err, res, body) ->
      try
        data = JSON.parse body
        children = data.data.children
        joke = msg.random(children).data

        joketext = joke.title.replace(/\*\.\.\.$/,'') + ' ' + joke.selftext.replace(/^\.\.\.\s*/, '')

        msg.send "A joke?!\nI got a good one: " + joketext.trim()

      catch ex
        msg.send "Erm, something went EXTREMELY wrong - #{ex}"
