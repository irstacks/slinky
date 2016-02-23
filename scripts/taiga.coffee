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
  username = process.env.HUBOT_TAIGA_USERNAME
  password = process.env.HUBOT_TAIGA_PASSWORD
  global_project = process.env.HUBOT_TAIGA_PROJECT
  project_not_set_msg = "Set project with `taiga project PROJECT_SLUG`"
  url = process.env.HUBOT_TAIGA_URL or "https://api.taiga.io/api/v1/"
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


  robot.hear /taiga info/i, (msg) ->
    project = getProject(msg)
    if project
      msg.send "Taiga project for #{msg.message.room} is #{project}"
    else
      msg.send "No Taiga project set for #{msg.message.room}."
      msg.send project_not_set_msg
    msg.send "Using #{username} for username"
    if password
      msg.send "Password is set"
    else
      msg.send "Password isn't set"
    msg.send "You are #{msg.message.user.name}"
    token = getUserToken(msg)
    if token
      msg.send "You are logged in - comments will be posted by your Taiga user"
    else
      msg.send "You are not logged in. You can post comments as yourself by logging in with `taiga auth username password.`"


  robot.hear /taiga project (.*)/i, (msg) ->
    project_slug = msg.match[1]
    key = getProjectKey(msg)
    robot.brain.set key, project_slug
    msg.send "Set room #{msg.message.room} to use project #{project_slug}"

  robot.hear /taiga auth (.*) (.*)/i, (msg) ->
    username = msg.match[1]
    password = msg.match[2]
    data = JSON.stringify({
      type: "normal",
      username: username,
      password: password
    })
    robot.http(url + 'auth')
      .headers('Content-Type': 'application/json')
      .post(data) (err, res, body) ->
        data = JSON.parse body
        token = data.auth_token
        if token
          key = "#{redis_prefix}#{msg.message.user.name}_token"
          robot.brain.set key, token
          msg.send "Authenication to Taiga.io successful"
        else
          msg.send "Authentication Failed"


  robot.hear /TG-(\d*) (.*)/i, (msg) ->
    project = getProject(msg)
    if not project
      msg.send project_not_set_msg
      return

    tid = msg.match[1]
    payload = msg.match[2]
    token = getUserToken(msg)

    if token
      submitComment(msg, token, project, tid, payload)
    else
      data = JSON.stringify({
        type: "normal",
        username: username,
        password: password
      })
      robot.http(url + 'auth')
        .headers('Content-Type': 'application/json')
        .post(data) (err, res, body) ->
          data = JSON.parse body
          token = data.auth_token
          if token
            submitComment(msg, token, project, tid, payload)
          else
            msg.send "Unable to authenticate"

  robot.hear /taiga get all userstories/i, (msg) ->
    project = getProject(msg)
    if not project
      msg.send project_not_set_msg
      return

    token = getUserToken(msg)

    if token
      getAllUserStories(msg, token, project)
    else
      data = JSON.stringify({
        type: "normal",
        username: username,
        password: password
      })
      robot.http(url + 'auth')
        .headers('Content-Type': 'application/json')
        .post(data) (err, res, body) ->
          data = JSON.parse body
          token = data.auth_token
          if token
            getAllUserStories(msg, token, project)
          else
            msg.send "Unable to authenticate"

  getAllUserStories = (msg, token, projectSlug) ->
    data = "?project=#{projectSlug}"
    auth = "Bearer #{token}"
    robot.http(url + "userstories" + data)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.stringify body

        if data
          # Test to make sure we get data.
          msg.send data

        else
          msg.send "Couldn't get data."

  submitComment = (msg, token, projectSlug, tid, payload) ->
    chatUsername = msg.message.user.name
    comment = "#{chatUsername}: #{payload}"
    auth = "Bearer #{token}"
    data = "?project=#{projectSlug}&us=#{tid}"
    robot.http(url + 'resolver' + data)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.parse body
        us = data.us

        if us
          project = data.project
          sendReference(msg, auth, us, comment, project, "user story")
        else
          checkIfIssue(msg, auth, tid, comment, projectSlug)


  checkIfIssue = (msg, auth, tid, comment, projectSlug) ->
    data = "?project=#{projectSlug}&issue=#{tid}"
    robot.http(url + 'resolver' + data)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.parse body
        issue = data.issue

        if issue
          project = data.project
          sendReference(msg, auth, issue, comment, project, "issue")
        else
          checkIfTask(msg, auth, tid, comment, projectSlug)


  checkIfTask = (msg, auth, tid, comment, projectSlug) ->
    data = "?project=#{projectSlug}&task=#{tid}"
    robot.http(url + 'resolver' + data)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.parse body
        task = data.task

        if task
          project = data.project
          sendReference(msg, auth, task, comment, project, "task")
        else
          msg.send "Couldn't find TG REF #{tid}"


  sendReference = (msg, auth, reference, comment, project, type) ->
    switch type
      when "user story" then fullUrl = url + 'userstories/' + reference
      when "issue" then fullUrl = url + 'issues/' + reference
      when "task" then fullUrl = url + 'tasks/' + reference

    robot.http(fullUrl)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.parse body
        version = data.version
        data = {
          "comment": comment,
          "version": version
        }
        match = statusPattern.exec(comment)
        if match
          statusSlug = match[1].slice(1)
          getReferenceStatuses(msg, auth, reference, project, statusSlug, data, type)
        else
          postReference(msg, auth, reference, data, type)


  getReferenceStatuses = (msg, auth, reference, project, statusSlug, data, type) ->
    switch type
      when "user story" then fullUrl = "#{url}userstory-statuses?project=#{project}"
      when "issue" then fullUrl = "#{url}issue-statuses?project=#{project}"
      when "task" then fullUrl = "#{url}task-statuses?project=#{project}"

    robot.http(fullUrl)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        statuses = JSON.parse body
        for status in statuses
          if status.slug == statusSlug
            data.status = status.id
        if data.status
          postReference(msg, auth, reference, data, type)
        else
          msg.send "Unable to find #{type} status #{statusSlug}."


  postReference = (msg, auth, reference, data, type) ->
    data = JSON.stringify(data)

    switch type
      when "user story" then fullUrl = url + 'userstories/' + reference
      when "issue" then fullUrl = url + 'issues/' + reference
      when "task" then fullUrl = url + 'tasks/' + reference

    robot.http(fullUrl)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .patch(data) (err, res, body) ->
        reference = JSON.parse body
        if err or not reference.id
          msg.send "Failed to update #{type}"
