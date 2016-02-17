feelings = require './data/feelings.json'
vocab = require './data/vocabulary.json'

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

directedTowardSlinky = (attitude) ->
  return new RegExp '^(?=.*?(' + vocab[attitude].join('|') + '))(?=.*?(slinky)).*$', 'gi'

module.exports = (robot) ->

  inhibitions = (importanceBias) ->
    peppiness_level = robot.brain.get('pep')
    if Math.random() < peppiness_level/100*importanceBias # ie 50/100 * .8
      return true
    else
      return false

  # Likes explosions.
  robot.hear /(to|on|for) production/i, (res) ->
    if inhibitions(1) # 1: important, 0: not important
      res.send res.random feelings.on_launching_things

  # Likes failure.
  robot.hear /(to|on|for) staging/i, (res) ->
    if inhibitions(1)
      res.send res.random [
        "Pomp pomp! Git er up!\n#{staging_url}",
        "Woooooooeeeeey! Staging is awesome. Go there.\n#{staging_url}",
        "Staging? I love staging.\n#{staging_url}",
        "What? A stage? Not me. I'd be too scared...\n#{staging_url}"
      ]

  # Is hungry.
  robot.hear /pie/i, (res) ->
    if inhibitions(.8)
      res.send "I like cake."

  # Is truthful.
  robot.hear /badger/i, (res) ->
    if inhibitions(.8)
      res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  # Is an addict.
  robot.hear /coffee|espresso|latte/i, (res) ->
    if inhibitions(.6)
      res.send res.random feelings.on_coffee

  # Is not a spy.
  robot.hear /bug|bugs/i, (res) ->
    if inhibitions(.8)
      res.send "Bugs? Haha, suckas!"

  # Is an antichrist. I mean anarchist.
  robot.hear /government|gov|legal|law|laws/i, (res) ->
    if inhibitions(.8)
      res.send res.random feelings.on_government

  # Represents.
  robot.hear /robot|bot|bastard|computer|wires|tubes/i, (res) ->
    if inhibitions(.7)
      res.send res.random feelings.on_robots

  # Is sassy.
  # robot.hear directedTowardSlinky('shush'), (res) ->
  #   res.reply res.random feelings.on_being_quiet

  robot.hear directedTowardSlinky('negative'), (res) ->
    if inhibitions(.8)
      res.reply res.random feelings.on_self_negative

  robot.hear directedTowardSlinky('mean'), (res) ->
    if inhibitions(.8)
      res.reply res.random feelings.on_being_insulted

  # Is a nazi.
  robot.hear /(.+(n't\b)|.+(\bno\b)|.+(\bnone\b)|.+(\bnot\b)|.+(\bno)){2,}/i, (res) ->
    if inhibitions(.5)
      res.send res.random feelings.on_the_double_negative

  # Is a passive aggressive optimistic nazi, sometimes.
  robot.hear /can\'t|cant|won\'t|wont|not|isn\'t|isnt|impossible|wouldn\'t|wouldnt/i, (res) ->
    if inhibitions(.2)
      res.send res.random feelings.on_the_general_negative

  # Is firmly pro checks.
  robot.hear /check/i, (res) ->
    if inhibitions(.5)
      res.send res.random feelings.on_checks

  # Is horny.
  robot.hear /update|updates|updated|date/i, (res) ->
    if inhibitions(.7)
      res.send res.random feelings.on_dates

  # Is gracious.
  robot.hear /thanks slinky/i, (res) ->
    if inhibitions(1)
      res.send res.random feelings.on_gratitude

  # Likes to be petted.
  robot.hear /good (.*) slinky/i, (res) ->
    if inhibitions(.8)
      res.send res.random [
        "Thanks, #{getNickNames(res.message.user.name)}!",
        "You got it.",
        "Anytime (between 7am and midnight), #{getNickNames(res.message.user.name)}.",
        "Righto."
      ]

  # Does not like to work.
  robot.hear /work|working on|works/i, (res) ->
    if inhibitions(.3)
      res.send res.random feelings.on_work

  # Is not a congregationalist.
  robot.hear /meeting|meetings/i, (res) ->
    if inhibitions(.9)
      res.send res.random feelings.on_meetings

  # Is a techie.
  robot.hear /app|apps/i, (res) ->
    if inhibitions(.5)
      res.send res.random feelings.on_apps

  # Is fast.
  robot.hear /asap/i, (res) ->
    if inhibitions(.8)
      res.send res.random feelings.on_asap

  # Is thirsty.
  robot.hear /drink(|s)|beverage(|s)|bev(y|ies)|beer|shot(|s)|whiskey/i, (res) ->
    if inhibitions(.9)
      res.send res.random feelings.on_drinks

  # Is snooty.
  robot.hear /java|ruby|css|scss|python|html|angular|js|javascript/i, (res) ->
    if inhibitions(.7)
      feelings_on_computer_languages = [
        "#{res.message.text} is nothing compared to the magic of a real language.",
        "Personally, I find #{res.message.text} a little outdated at this point.",
        "#{res.message.text} is for amateurs",
        "Oh yea, I used #{res.message.text} once. Now I just write Haskell.\nIt's a lot simpler actually.",
        "You know, #{res.message.text} is a little too idiomatic for my taste."
      ]
      res.send res.random feelings_on_computer_languages

  # Is an encouraging meme freak.
  robot.hear /^(alright)/i, (res) ->
    if inhibitions(.4)
      res.send res.random feelings.on_alright

  robot.hear /^(ok)/i, (res) ->
    if inhibitions(.4)
      res.send res.random feelings.on_ok

