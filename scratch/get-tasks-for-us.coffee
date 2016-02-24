# Get all tasks for specific userstory.
# Now accepting US:id.
# https://api.taiga.io/api/v1/tasks/by_ref?ref=1&project=1
robot.hear /taiga (task|tasks) us:(\d+) (list)?/i, (msg) ->

  usid = msg.match[2]
  project = getProject(msg)
  if not project
    msg.send project_not_set_msg
    return

  token = getUserToken(msg)

  if token
    getTasksForUserstory(msg, token, project, usid)
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
          getTasksForUserstory(msg, token, project, usid)
        else
          msg.send "Unable to authenticate"


getTasksForUserstory = (msg, token, projectSlug, usid) ->
  data = "?project=#{projectSlug}"
  auth = "Bearer #{token}"

  # Get project id.
  robot.http(url + 'resolver' + data)
    .headers('Content-Type': 'application/json', 'Authorization': auth)
    .get() (err, res, body) ->
      data = JSON.parse body
      pid = data.project
      if pid

        data = "&user_story=#{usid}" # "/byref?ref=#{usid}&project=#{pid}"
        auth = "Bearer #{token}"

        robot.http(url + 'tasks' + data)
          .headers('Content-Type': 'application/json', 'Authorization': auth)
          .get() (err, res, body) ->

            task_list = JSON.parse body

            if task_list
              # if task_list.length > 0
              say = "Task list for US:#{usid}"
              say += formatted_reponse(task, '/tasks') for task in task_list
              msg.send say
              # else
              #   msg.send "There are no tasks for US:#{usid}"

            else
              msg.send "Unable to retrieve tasks for userstory w/ id: #{usid}"
