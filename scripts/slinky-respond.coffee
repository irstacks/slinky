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
