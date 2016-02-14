# Jokes.
module.exports = (robot) ->
  robot.respond /joke|funny/i, (msg) ->
    name = msg.match[1].trim()

    if name is "dad"
      url = "dadjokes"
    else if name is "clean"
      url = "cleanjokes"
    else if name is "mom"
      url = "mommajokes"
    else if name is "classy"
      url = "classyjokes"
    else
      url = "jokes"

    msg.http("http://www.reddit.com/r/#{url}.json")
    .get() (err, res, body) ->
      try
        data = JSON.parse body
        children = data.data.children
        joke = msg.random(children).data

        joketext = joke.title.replace(/\*\.\.\.$/,'') + ' ' + joke.selftext.replace(/^\.\.\.\s*/, '')

        msg.send "Funny? I got a good one: " + joketext.trim()

      catch ex
        msg.send "Erm, something went EXTREMELY wrong - #{ex}"
