feelings = require './data/feelings.json'
staging_url = process.env.HUBOT_STAGING_URL

getNickNames = (username) ->
  if (username is 'yaya')
    # TODO: randomizer
    'big mama'
  else if (username is 'iiabney')
    'big I'
  else if (username is 'therealia')
    'big papa'
  else if (username is 'james')
    'big J'

module.exports = (robot) ->

  # Deployables.
  robot.hear /to production/i, (res) ->
    res.send res.random feelings.on_launching_things

  robot.hear /staging/i, (res) ->
    res.send res.random [
      "Pomp pomp! Git er up!\n#{staging_url}",
      "Woooooooeeeeey! Staging is awesome. Go there.\n#{staging_url}",
      "Staging? I love staging.\n#{staging_url}",
      "What? A stage? Not me. I'd be too scared...\n#{staging_url}"
    ]

  # I like pie, I like cake.
  robot.hear /pie/i, (res) ->
    res.send "I like cake."

  # Badgers
  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  robot.hear /coffee|espresso|latte/i, (res) ->
    res.send res.random feelings.on_coffee

  robot.hear /can\'t|cant|won\'t|wont|not|isn\'t|isnt|impossible|wouldn\'t|wouldnt/i, (res) ->
    res.send res.random feelings.on_the_general_negative

  robot.hear /(slinky.+)?(can't|don't|cant|won't|wont|not|isn't|isnt|impossible|wouldn't|wouldnt)(.+slinky)?/i, (res) ->
    res.send res.random feelings.on_self_negative

  robot.hear /bug|bugs/i, (res) ->
    res.send "Bugs? Haha, suckas!"

  robot.hear /government|gov|legal|law|laws/i, (res) ->
    res.send res.random feelings.on_government

  robot.hear /robot|bot|bastard|computer|wires|tubes/i, (res) ->
    res.send res.random feelings.on_robots

  robot.hear /(.+nt|.+(n't)|.+no){2,}/i, (res) ->
    res.send res.random feelings.on_the_double_negative

  robot.hear /(slinky.+)?(snarky|bitch|bastard|idiot|motherfucker|muthafucka|fuck you|asshole)(.+slinky)?/i, (res) ->
    res.send res.random feelings.on_being_insulted

  robot.hear /check/i, (res) ->
    res.send res.random feelings.on_checks

  robot.hear /update|updates|updated|date/i, (res) ->
    res.send res.random feelings.on_dates

  robot.hear /thanks slinky/i, (res) ->
    res.send res.random feelings.on_gratitude

  robot.hear /good (.*) slinky/i, (res) ->
    res.send res.random [
      "Thanks, #{getNickNames(res.message.user.name)}!",
      "You got it.",
      "Anytime (between 7am and midnight), #{getNickNames(res.message.user.name)}.",
      "Word up."
    ]

  robot.hear /work|working on|works/i, (res) ->
    res.send res.random feelings.on_work

  robot.hear /meeting|meetings/i, (res) ->
    res.send res.random feelings.on_meetings

  robot.hear /app|apps/i, (res) ->
    res.send res.random feelings.on_apps

  robot.hear /asap/i, (res) ->
    res.send res.random feelings.on_asap

  robot.hear /drink|drinks/i, (res) ->
    res.send res.random feelings.on_drinks

  robot.hear /java|ruby|css|scss|python|html|angular|js|javascript/i, (res) ->
    feelings_on_computer_languages = [
      "#{res.message.text} is nothing compared to the magic of a real language.",
      "Personally, I find #{res.message.text} a little outdated at this point.",
      "#{res.message.text} is for amateurs",
      "Oh yea, I used #{res.message.text} once. Now I just write Haskell.\nIt's a lot simpler actually.",
      "You know, #{res.message.text} is a little too idiomatic for my taste."
    ]
    res.send res.random feelings_on_computer_languages

