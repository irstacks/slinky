spacelaunch = [
  "http://starchild.gsfc.nasa.gov/Images/StarChild/space_level2/sts9_columbia.gif"
]

tophers = [
  '31555931', #Homework...
  '1931795771', #Pogue LED continuum
  '4119156292', #Windows 8 start menu prescience
  '7250133137', #rotating out of the aughts
  '7111916773', #scarecrow's thoughtfulness
  '6557934634', #@office @googlewave factchecker
  '7810280394', #twitter outgoing lists
  '7425684611', #creating gelato fiasco foursquare venue
  '7266553623', ##10yearsago i was asleep
  '9582322439', #pocket-tweet
  '8787585042', #last year's super bowl
  '11337955968', #introducing scoober to mailchimp lol
  '11289192552', #implied trivalent predicate
  '11289098252', #Things That Return No Google Results But Should #1 artificially augmented proprioception
  '10965467296', #hygiene hypothesis
  '10959424388', #we often say be yourself
  '10663073432', #contract with creators of lost
  '10660590984', #best thing we can do for the earth is get off of it
  '10641145325', #twoosh novelty
  '10498282576', #RIP Oveur, over
  '10463525810', #whoah it's 5:20
  '10357473750', #first geolocated tweet
  '13095878920', #perfect enemy of good
  '13095853833', #adjectives, adverbs, then what?
  '13039741275', #five websites

  # ok, pick up where you left off one day and keep curating:
  # file:#localhost/Users/tophtucker/Dropbox/Archives/tweets/index.html#

  '181191415148191744', # Practice makes better

  '186581115753074688', # Apr 1 12: Island of misfit toys
  '186581956404842496', # cont.
  '186583662828060672',
  '186584736444063744',
  '186585214267572224',
  '186585834584150016',

  '186708960777216000', # Apr 1 12: anthropic doomsday principle
  '186713150568153089' # Apr 1 12: go home and hug your children mode
]

module.exports = (robot) ->

  # Deployables.
  robot.hear /staging/i, (res) ->
    res.send "#Pomp pomp!"

  robot.hear /production/i, (res) ->
    res.send res.random spacelaunch

  # I like pie, I like cake.
  robot.hear /pie/i, (res) ->
    res.send "I like cake"

  # Badgers
  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  # Slow.
  robot.respond /you are a little slow/, (res) ->
    setTimeout () ->
      res.send "Who you calling 'slow'?"
    , 60 * 1000

  robot.respond /coffee/i, (res) ->
    res.send "#{res.message.text}? Make mine a breve, extra hot."

  # robot.respond /topher/i, (res) ->
  #   robot.http("https://twitter.com/tophtucker/status/186585834584150016")
  #       .get() (err, res, body) ->
  #         res.send "res: #{res} \n body: #{body}"
    # res.send res.random tophers

    robot.respond /topher/i, (res) ->
    # Configures the url of a remote server
       msg.http('https://twitter.com/tophtucker/status/186585834584150016')
           # and makes an http get call
           .get() (error, response, body) ->
               # passes back the complete reponse
               msg.send body

  # robot.respond /httper/i, (res) ->





