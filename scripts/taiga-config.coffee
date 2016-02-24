# Description:
#   Send Taiga.io commands via hubot
#
# Dependencies:
#   "hubot-taiga": "0.1"
#
# Configuration:
#   HUBOT_TAIGA_USERNAME
#   HUBOT_TAIGA_PASSWORD
#   HUBOT_TAIGA_PROJECT
#   HUBOT_TAIGA_URL
#
# Commands:
#   taiga info - Displays infomation about Taiga connection for user
#   taiga project <project-slug> - Set taiga project for this channel
#   taiga auth <username> <password> - Authenticate so that comments from from this user
#   TG-<REF> <comment> - Send a comment to Taiga. Example `TG-123 I left a comment!` and `TG-123 #done I finished it, I am the best.`
#
#   taiga (us|userstory) list - List all open userstories.
#   taiga (us|userstory) show 34
#   taiga (us|userstory) add subject:The beginning of long journey description: The Road goes on.
#   taiga (us|userstory) edit 34 status close - Edit userstory by ID.
#
#   taiga (task|tasks) list - List all open tasks.
#   taiga (task|tasks) us:34 - List all tasks for userstory by ID.
#   taiga (task|tasks) add us:34 subject:Do it. description:And do it good.
#   taiga (task|tasks) edit 52 status done - Edit task by ID.
#
#   taiga post userstory (.*) - Post a userstory with subject ___
#
#
# Notes:
#   Environment variables are optional.
#   If you use tree.taiga.io and wish to have each user log in as themselves - there is no need to set them
#
#   Set username and password if you would rather have a Hubot user submit for all users
#   If you want users to post as themselves they should use `taiga auth <username> <password>`.
#   Consider the security implications of having password set in your chat service.
#
#   Set project if you would like a global default project set.
#   Otherwise use `taiga project <project-slug>` to set the project per channel
#
# Author:
#   David Burke


module.exports = (robot) ->

  ####### Helpers and init inherited from Mr. Burke.

  username = process.env.HUBOT_TAIGA_USERNAME
  password = process.env.HUBOT_TAIGA_PASSWORD
  global_project = process.env.HUBOT_TAIGA_PROJECT
  project_not_set_msg = "Set project with `taiga project PROJECT_SLUG`"
  url = process.env.HUBOT_TAIGA_URL or "https://api.taiga.io/api/v1/"
  taiga_tree_url = "https://tree.taiga.io/project/"
  redis_prefix = 'taiga_'
  statusPattern = /(#[^\s]+)/i


  getProject = (msg) ->
    key = getProjectKey(msg)
    project = robot.brain.get(key)
    if project
      project
    else
      global_project


  getUserToken = (msg) ->
    key = "#{redis_prefix}#{msg.message.user.name}_token"
    token = robot.brain.get(key)
    if token
      token


  getProjectKey = (msg) ->
    project_key = redis_prefix + 'project'
    room = msg.message.room
    project_key + room
