

spacelaunch = [
  "http://starchild.gsfc.nasa.gov/Images/StarChild/space_level2/sts9_columbia.gif"
]

feelings_on_government = [
  "Me personally, I'm an antichrist. \n Anarchist, whatever.",
  "Tyranny in government is in the positive, freedom in the negative.\n Thanks for asking.",
  "Government?? GOVERNMENT??!\n Barricades people! Bar the doors. "
]

feelings_on_coffee = [
  "Breve, please, extra hot.",
  "I'll take two. Thanks.",
  "You're an addict, man.",
  "Well, I like my coffee like I like my women."
]

feelings_on_robots = [
  "Huh?! Jew talkin bout me?",
  "But I am more than a robot.",
  "I am robot.",
  "Hey! Be all you can be, that's what I say.",
  "I knew I should have joined the Marines.",
  "And you are a snot nosed human weakling."
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

  robot.hear /slinky|this robot|bastard|computer/i, (res) ->
    res.send res.random feelings_on_robots

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





