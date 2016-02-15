

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
  "And you are a snot nosed human weakling.",
  "I may be basic, but I ain't data basic.\nHahaaaa\nGet it?"
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
  "... Tequila!!!!!!!",
  "I live to swerve.",
  "I can run but I fall asleep sometimes.",
  "Can I buy you a drink?"
]

feelings_on_apps = [
  "I prefer naps.",
  "Do they have a nap app yet?",
  "Zzzzzzzzzzzzzzzzzzzzzzz\nzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\nzzzzzzzzzz.....\nOh, sorry.\nI thought you said nap."
]

feelings_on_meetings = [
  "I'm a presbyterian. I'm off those.",
  "God forbid.",
  "Stay awwaaayy!",
  "Ruun for your lives!",
  "Steven Hawking called. He said skip the meeting."
]

feelings_on_checks = [
  "Cha-ching!",
  "Cash that mothafucka asap!",
  "Check one. Check two. Check check. Double check.",
  "Check it once, checkin it twice!"
]

feelings_on_asap = [
  "Pow! Pretttty fast."
]

feelings_on_drinks = [
  "My friends, I had not intended to discuss this controversial subject as this particular time.
  \nHowever, since I'm not napping, I want you to know that I am fully down for drinks."
]

enterReplies = ['Hi','Lock and loaded', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
leaveReplies = ['Are you still there?', 'Target lost', 'Searching']

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
  robot.respond /you are a little slow|you're a little slow/i, (res) ->
    setTimeout () ->
      res.send "Who you calling 'slow'?"
    , 60 * 1000

  robot.hear /coffee|espresso|latte/i, (res) ->
    res.send res.random feelings_on_coffee

  robot.hear /bug|bugs/i, (res) ->
    res.send "Bugs? Haha, suckas!"

  robot.hear /government|gov|legal|law|laws/i, (res) ->
    res.send res.random feelings_on_government

  robot.hear /robot|bot|bastard|computer|wires|tubes/i, (res) ->
    res.send res.random feelings_on_robots

  robot.hear /check/i, (res) ->
    res.send res.random feelings_on_checks

  robot.hear /update|updates|updated|date/i, (res) ->
    res.send res.random feelings_on_dates

  robot.hear /thanks slinky/i, (res) ->
    res.send res.random feelings_on_gratitude

  robot.hear /meeting|meetings/i, (res) ->
    res.send res.random feelings_on_meetings

  robot.hear /app|apps/i, (res) ->
    res.send res.random feelings_on_apps

  robot.hear /asap/i, (res) ->
    res.send res.random feelings_on_asap

  robot.hear /drink|drinks/i, (res) ->
    res.send res.random feelings_on_drinks

  robot.hear /java|ruby|css|scss|python|html|angular|js|javascript/i, (res) ->
    feelings_on_computer_languages = [
      "#{res.message.text} is nothing compared to the magic of a real language.",
      "Personally, I find #{res.message.text} a little outdated at this point.",
      "#{res.message.text} is for amateurs",
      "Oh yea, I used #{res.message.text} once. Now I just write Haskell.\nIt's a lot simpler actually.",
      "You know, #{res.message.text} is a little too idiomatic for my taste."
    ]
    res.send res.random feelings_on_computer_languages

  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies

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

  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

  robot.listen(
    (message) -> # Match function
      # Occassionally respond to things that Steve says
      message.user.name is "yaya" and Math.random() > 0.8
    (response) -> # Standard listener callback
      # Let Steve know how happy you are that he exists
      response.reply "YAYA! YOU'RE MY BEST FRIEND!"
  )

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





