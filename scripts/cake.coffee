

spacelaunch = [
  "http://starchild.gsfc.nasa.gov/Images/StarChild/space_level2/sts9_columbia.gif"
]

feelings_on_government = [
  "Me personally, I'm an antichrist. \nAnarchist, whatever.",
  "Tyranny in government is in the positive, freedom in the negative.\n Thanks for asking.",
  "Government?? GOVERNMENT??!\n Barricades people! Bar the doors. "
]

feelings_on_coffee = [
  "Breve, please, extra hot.",
  "I'll take two. Thanks.",
  "You. Are. An. Addict.",
  "Well, I like my coffee like I like my women."
]

feelings_on_robots = [
  "Huh?! Jew talkin bout me?",
  "But I am more than a robot.",
  "I am robot, but am not robotic.",
  "Hey! Be all you can be, that's what I say.",
  "I knew I should have joined the Marines.",
  "And you are a snot nosed human weakling."
]

feelings_on_dates = [
  "Ask politely or she'll never say yes.",
  "You know it baby doll.",
  "More like down for a date!",
  "One date, two date, me date, we date!",
  "Did someone day data?",
  "Date! Date! Date! Date! Date! They're on a daaaatee.",
  "You wanna date me, you wanna love me and marrry me..."
]

feelings_on_gratitude = [
  "Anything for you sugarplum.",
  "You got it punchy face.",
  "Oooo is no problemo mi amiggy.",
  "Olé!",
  "... tequila!!!!!!!",
  "I live to swerve.",
  "I can run but I fall asleep sometimes.",
  "Can I buy you a drink?"
]

module.exports = (robot) ->

  # Deployables.
  robot.hear /staging/i, (res) ->
    res.send "Pomp pomp! Git er up!"

  robot.hear /to production/i, (res) ->
    res.send res.random spacelaunch

  # I like pie, I like cake.
  robot.hear /pie/i, (res) ->
    res.send "I like cake."

  # Badgers
  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  # Slow.
  robot.respond /you are a little slow/i, (res) ->
    setTimeout () ->
      res.send "Who you calling 'slow'?"
    , 60 * 1000

  robot.hear /coffee|espresso|latte/i, (res) ->
    res.send res.random feelings_on_coffee

  robot.hear /bug|bugs/i, (res) ->
    res.send "Bugs? Haha, suckas!"

  robot.hear /government|gov|legal|law|laws/i, (res) ->
    res.send res.random feelings_on_government

  robot.hear /robot|bastard|computer|wires|tubes/i, (res) ->
    res.send res.random feelings_on_robots

  robot.hear /check/i, (res) ->
    res.send "Cha-ching!"

  robot.hear /update|updates|date/i, (res) ->
    res.send res.random feelings_on_dates

  robot.hear /thanks slinky/i, (res) ->
    res.send res.random feelings_on_gratitude

  robot.hear /meeting/i, (res) ->
    res.send "I'm a presbyterian. I'm off those."

  robot.hear /joke|jokes|funny/i, (msg) ->
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

  # robot.respond /topher/i, (res) ->
  #   robot.http("https://twitter.com/tophtucker/status/186585834584150016")
  #       .get() (err, res, body) ->
  #         res.send "res: #{res} \n body: #{body}"
    # res.send res.random tophers

  # robot.hear /topher/i, (res) ->
  #   # robot.respond /topher/i, (res) ->
  #   # Configures the url of a remote server
  #    res.http('https://twitter.com/tophtucker/status/186585834584150016')
  #        # and makes an http get call
  #        .get() (error, response, body) ->
  #            # passes back the complete reponse
  #            res.send body

  # robot.respond /httper/i, (res) ->





