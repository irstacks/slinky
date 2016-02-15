module.exports = (robot) ->

  staging_url = process.env.HUBOT_STAGING_URL

  staging_is_awesome = [
    "Pomp pomp! Git er up!\n#{staging_url}",
    "Woooooooeeeeey! Staging is awesome. Go there.\n#{staging_url}",
    "Staging? I love staging.\n#{staging_url}",
    "What? A stage? Not me. I'd be too scared...\n#{staging_url}"
  ]

  # Deployables.
  robot.hear /to production/i, (res) ->
    res.send res.random spacelaunch

  robot.hear /staging/i, (res) ->
    res.send res.random staging_is_awesome
