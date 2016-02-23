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
#   taiga get userstories - Get a list of all open userstories.
#   taiga post userstory (.*) - Post a userstory with subject ___

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


  robot.hear /taiga post userstory (.*)/i, (msg) ->
    incoming_subject = msg.match[1]

    project = getProject(msg)
    if not project
      msg.send project_not_set_msg
      return

    token = getUserToken(msg)

    if token
      createUserstory(msg, token, project, incoming_subject)
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
            createUserstory(msg, token, project, incoming_subject)
          else
            msg.send "Unable to authenticate"

  createUserstory = (msg, token, projectSlug, subjectable) ->
    # Use for grabbing resolved project id.
    data = "?project=#{projectSlug}"
    auth = "Bearer #{token}"

    # Get project id.
    robot.http(url + 'resolver' + data)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.parse body
        pid = data.project

        # If we resolve the project id.
        if pid
          postable_obj = {
            project: pid,
            subject: subjectable
          }
          postable_json = JSON.stringify postable_obj

          robot.http(url + '/userstories')
            .headers('Content-Type': 'application/json', 'Authorization': auth)
            .post(postable_json) (err, res, body) ->
              reference = JSON.parse body
              if err or not reference.id
                msg.send "Failed to create userstory."
              else
                msg.send "Created <#{taiga_tree_url}#{getProject(msg)}/us/#{reference.id}|#{subjectable}>."
        else
          msg.send "Couldn't get the pid."


  robot.hear /taiga get userstories/i, (msg) ->
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

    # Get project id.
    robot.http(url + 'resolver' + data)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.parse body
        pid = data.project

        if pid
          # Get list userstories for project where status_is_closed=false.
          data = "?project=#{pid}&status__is_closed=false"
          robot.http(url + '/userstories' + data)
            .headers('Content-Type': 'application/json', 'Authorization': auth)
            .get() (err, res, body) ->
              userstories = JSON.parse body

              if userstories
                say = ""
                say += relevantUserstoryInfo(userstory) for userstory in userstories
                msg.send say

              else
                msg.send "Couldn't get data for project with id #{pid}."
        else
          msg.send "Couldn't get the pid."


  relevantUserstoryInfo = (userstory) ->
    words = ""
    words += userstory['id'] + " - "
    words += "*" + userstory['subject'] + "* "
    words += "_" + userstory['status_extra_info']['name'] + "_ "
    if userstory['assigned_to_extra_info']
      words += "(" + userstory['assigned_to_extra_info']['full_name_display'] + ")" + "\n"
    else
      words += "\n"

    return words


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


  #####################################################

  getPID = (token, projectSlug) ->
    data = "?project=#{projectSlug}"
    auth = "Bearer #{token}"

    # Get project id.
    robot.http(url + 'resolver' + data)
      .headers('Content-Type': 'application/json', 'Authorization': auth)
      .get() (err, res, body) ->
        data = JSON.parse body
        pid = data.project
        return pid

  getBotToken = () ->
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
        return token

  # Get all tasks or userstories.
  robot.hear /taiga (us|userstory|userstories|task|tasks) list/i, (msg) ->
    project = getProject(msg)
    if not project
      msg.send project_not_set_msg
      return

    resource_type = msg.match[1]

    switch resource_type
      when 'us','userstory','userstories' then resource_path = '/userstories'
      when 'task','tasks' then resource_path = '/tasks'

    token = getUserToken(msg)

    if token
      getAllResource(msg, token, project, resource_path)
    else
      if getBotToken()
        getAllResource(msg, token, project, resource_path)
      else
        msg.send "Unable to authenticate"

  getAllResource = (msg, token, projectSlug, resource_path) ->
    if getPID(token, projectSlug)
      # Get list userstories/tasks for project where status_is_closed=false.
      data = "?project=#{pid}&status__is_closed=false"
      robot.http(url + resource_path + data)
        .headers('Content-Type': 'application/json', 'Authorization': auth)
        .get() (err, res, body) ->
          response_list = JSON.parse body

          if response_list
            say = ""
            say += formatted_reponse(item, resource_path) for item in response_list
            msg.send say

          else
            msg.send "Couldn't get data for project with id #{pid}."
    else
      msg.send "Couldn't get the pid."

  formatted_reponse = (item, resource_path) ->
    words = ""

    switch resource_path
      when '/userstories'
        words += "us:" + item['id'] + " - "
        words += "*" + item['subject'] + "* "
        words += "_" + item['status_extra_info']['name'] + "_ "
        words += "(" + item['assigned_to_extra_info']['full_name_display'] + ")" if item['assigned_to_extra_info']
        if item['description']
          words += "\n"
          words += "_" + item["description"] + "_"
          words += "\n"
        else
          words += "\n"
      when '/tasks'
        words += "task:" + item['id'] + " - "
        words += "*" + item['subject'] + "* "
        words += "_" + item['status_extra_info']['name'] + "_ "
        words += "(" + item['assigned_to_extra_info']['full_name_display'] + ")" if item['assigned_to_extra_info']
        if item['description']
          words += "\n"
          words += "_" + item["description"] + "_"
          words += "\n"
        else
          words += "\n"

    return words
