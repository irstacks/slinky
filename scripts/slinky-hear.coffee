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

  # Likes explosions.
  robot.hear /to production/i, (res) ->
    res.send res.random feelings.on_launching_things

  # Likes failure.
  robot.hear /staging/i, (res) ->
    res.send res.random [
      "Pomp pomp! Git er up!\n#{staging_url}",
      "Woooooooeeeeey! Staging is awesome. Go there.\n#{staging_url}",
      "Staging? I love staging.\n#{staging_url}",
      "What? A stage? Not me. I'd be too scared...\n#{staging_url}"
    ]

  # Is hungry.
  robot.hear /pie/i, (res) ->
    res.send "I like cake."

  # Is truthful.
  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  # Is an addict.
  robot.hear /coffee|espresso|latte/i, (res) ->
    res.send res.random feelings.on_coffee

  # Is not a spy.
  robot.hear /bug|bugs/i, (res) ->
    res.send "Bugs? Haha, suckas!"

  # Is an antichrist.
  robot.hear /government|gov|legal|law|laws/i, (res) ->
    res.send res.random feelings.on_government

  # Represents.
  robot.hear /robot|bot|bastard|computer|wires|tubes/i, (res) ->
    res.send res.random feelings.on_robots

  # Is sassy.
  robot.hear /(^(slinky)|(slinky)$)?(stop|quit|shut up|pipe down|put a lid on it|quiet)/i, (res) ->
    res.reply res.random feelings.on_being_quiet

  robot.hear /(^(slinky)|(slinky)$)?(can't|don't|cant|won't|wont|not|isn't|isnt|impossible|wouldn't|wouldnt)/i, (res) ->
    res.send res.random feelings.on_self_negative

  robot.hear /(^(slinky)|(slinky)$)?(snarky|bitch|bastard|idiot|motherfucker|muthafucka|fuck you|asshole|chump|mouse face)/i, (res) ->
    res.send res.random feelings.on_being_insulted

  # Is a nazi.
  robot.hear /(.+(n't\b)|.+(\bno\b)|.+(\bnone\b)|.+(\bnot\b)|.+(\bno)){2,}/i, (res) ->
    res.send res.random feelings.on_the_double_negative

  # Is a passive aggressive optimistic nazi.
  robot.hear /can\'t|cant|won\'t|wont|not|isn\'t|isnt|impossible|wouldn\'t|wouldnt/i, (res) ->
    res.send res.random feelings.on_the_general_negative

  # Is from the 21st century.
  robot.hear /check/i, (res) ->
    res.send res.random feelings.on_checks

  # Is horny.
  robot.hear /update|updates|updated|date/i, (res) ->
    res.send res.random feelings.on_dates

  # Is gracious.
  robot.hear /thanks slinky/i, (res) ->
    res.send res.random feelings.on_gratitude

  # Likes to be petted.
  robot.hear /good (.*) slinky/i, (res) ->
    res.send res.random [
      "Thanks, #{getNickNames(res.message.user.name)}!",
      "You got it.",
      "Anytime (between 7am and midnight), #{getNickNames(res.message.user.name)}.",
      "Word up."
    ]

  # Does not like to work.
  robot.hear /work|working on|works/i, (res) ->
    res.send res.random feelings.on_work

  # Is not a congregationalist.
  robot.hear /meeting|meetings/i, (res) ->
    res.send res.random feelings.on_meetings

  # Is a techie.
  robot.hear /app|apps/i, (res) ->
    res.send res.random feelings.on_apps

  # Is fast.
  robot.hear /asap/i, (res) ->
    res.send res.random feelings.on_asap

  # Is thirsty.
  robot.hear /drink|drinks|beverage|beverages|bevy|bevies|beer|shots|whiskey/i, (res) ->
    res.send res.random feelings.on_drinks

  # Is snooty.
  robot.hear /java|ruby|css|scss|python|html|angular|js|javascript/i, (res) ->
    feelings_on_computer_languages = [
      "#{res.message.text} is nothing compared to the magic of a real language.",
      "Personally, I find #{res.message.text} a little outdated at this point.",
      "#{res.message.text} is for amateurs",
      "Oh yea, I used #{res.message.text} once. Now I just write Haskell.\nIt's a lot simpler actually.",
      "You know, #{res.message.text} is a little too idiomatic for my taste."
    ]
    res.send res.random feelings_on_computer_languages

