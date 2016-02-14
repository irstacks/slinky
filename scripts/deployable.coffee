spacelaunch = [
  "http://starchild.gsfc.nasa.gov/Images/StarChild/space_level2/sts9_columbia.gif"
]

module.exports = (robot) ->

  robot.hear /staging/i, (res) ->
    res.send "#{res.message.text}? Pomp pomp!"

  robot.hear /production/i, (res) ->
    res.send res.random spacelaunch
