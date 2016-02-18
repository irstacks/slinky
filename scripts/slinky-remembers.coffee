# https://github.com/github/hubot-scripts/blob/master/src/scripts/factoid.coffee
# Description:
#   javabot style factoid support for your hubot. Build a factoid library
#   and save yourself typing out answers to similar questions
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   ~<factoid> is <some phrase, link, whatever> - Creates a factoid
#   ~<factoid> is also <some phrase, link, whatever> - Updates a factoid.
#   ~<factoid> - Prints the factoid, if it exists. Otherwise tells you there is no factoid
#   ~tell <user> about <factoid> - Tells the user about a factoid, if it exists
#   ~~<user> <factoid> - Same as ~tell, less typing
#   <factoid>? - Same as ~<factoid> except for there is no response if not found
#   hubot no, <factoid> is <some phrase, link, whatever> - Replaces the full definition of a factoid
#   hubot factoids list - List all factoids
#   hubot factoid delete "<factoid>" - delete a factoid
#
# Author:
#   arthurkalm

class Factoids
  constructor: (@robot) ->
    @robot.brain.on 'loaded', =>
      @cache = @robot.brain.data.factoids
      @cache = {} unless @cache

  add: (key, val) ->
    # "Key is #{key} and val is #{val}"
    input = key
    key = key.toLowerCase() unless @cache[key]?
    if @cache[key]
      "#{input} is already #{@cache[key]}"
    else
      this.setFactoid input, val
      "OK, #{input} is #{val}."

  append: (key, val) ->
    input = key
    key = key.toLowerCase() unless @cache[key]?
    if @cache[key]
      @cache[key] = @cache[key] + ", " + val
      @robot.brain.data.factoids = @cache
      "Ok. #{input} is also #{val} "
    else
      "No memory of #{input}. It can't also be #{val} if it isn't already something."

  setFactoid: (key, val) ->
    input = key
    key = key.toLowerCase() unless @cache[key]?
    @cache[key] = val
    @robot.brain.data.factoids = @cache
    "OK. #{input} is #{val} "

  delFactoid: (key) ->
    input = key
    key = key.toLowerCase() unless @cache[key]?
    delete @cache[key]
    @robot.brain.data.factoids = @cache
    "OK. I forgot about #{input}"

  niceGet: (key) ->
    input = key
    key = key.toLowerCase() unless @cache[key]?
    @cache[key] or "No memory of #{input}"

  get: (key) ->
    key = key.toLowerCase() unless @cache[key]?
    @cache[key]

  list: ->
    Object.keys(@cache)

  tell: (person, key) ->
    factoid = this.get key
    if @cache[key]
      "#{person}, #{key} is #{factoid}"
    else
      factoid

  handleFactoid: (text) ->
    # Setters.
    if match = /remember+( that)?( the)? (.*) also (is|are|as|equals) (.*)/i.exec text
      thing_to_remember_as = match[3] || match[2]
      thing_to_remember = match[6] || match[5]
      this.append thing_to_remember_as, thing_to_remember
    else if match = /remember+( that)?( the)? (.*) (is|are|as|equals) (.*)/i.exec text
      thing_to_remember_as = match[3] || match[2]
      thing_to_remember = match[5] || match[4]
      this.add thing_to_remember_as, thing_to_remember
    # Getters.
    # else if match = (/^~tell (.+?) about (.+)/i.exec text) or (/^~~(.+) (.+)/.exec text)
    #   this.tell match[1], match[2]
    else if match = /what(s|'s| is| are)+( the)? (.*)[?]?/i.exec text
      this.niceGet match[3]

module.exports = (robot) ->
  factoids = new Factoids robot

  # Chimes in if he knows the answer to a key question.
  robot.hear /(.+)\?/i, (msg) ->
    factoid = factoids.get msg.match[1]
    if factoid
      msg.reply msg.match[1] + " is " + factoid

  # Adjust his memory.
  robot.respond /no, (.+) is (.+)/i, (msg) ->
    msg.reply factoids.setFactoid msg.match[1], msg.match[2]

  # Spill the beans.
  robot.respond /(remember|tell me|list)?\b(everything|what do you know|show|) memor(y|ized)/i, (msg) ->
    msg.send factoids.list().join('\n')

  # Remove his memory.
  robot.respond /(memory )?(delete |forget )(.+)/i, (msg) ->
    msg.reply factoids.delFactoid msg.match[res.match.length-1]

  # Rememberer catcher for implanting and retrieving memories.
  robot.respond /remember|what/i, (res) ->
    # thing_to_remember_as = res.match[3]
    # thing_to_remember = res.match[5]
    res.reply factoids.handleFactoid res.message.text
