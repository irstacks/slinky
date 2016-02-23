  # Abstract post method for <resource>, where <resource> is userstory(==us)|task
  # could use /taiga post (.*) ((.*):(.*)) ((.*):(.*))/i for more variance, but that
  # becomes an issue of knowing offhand the taiga api.
  # simple or die.

  # Usage:

  # taiga (us|userstory) list
  # taiga (us|userstory) show 34
  # taiga (us|userstory) add subject:The beginning of long journey description: The Road goes on.
  # taiga (us|userstory) edit 34 status close - Edit userstory by ID.

  # taiga (task|tasks) list - List all tasks everywhere.
  # taiga (task|tasks) us:34 - List all tasks for userstory by ID.
  # taiga (task|tasks) add us:34 subject:Do it. description:And do it good.
  # taiga (task|tasks) edit 52 status done - Edit task by ID.

  ##################################################
# module.exports = (robot) ->



  ##################################################
# module.exports = (robot) ->

#   getPID = (token, projectSlug) ->
#     data = "?project=#{projectSlug}"
#     auth = "Bearer #{token}"

#     # Get project id.
#     robot.http(url + 'resolver' + data)
#       .headers('Content-Type': 'application/json', 'Authorization': auth)
#       .get() (err, res, body) ->
#         data = JSON.parse body
#         pid = data.project
#         return pid

#   getBotToken = () ->
#     data = JSON.stringify({
#       type: "normal",
#       username: username,
#       password: password
#     })
#     robot.http(url + 'auth')
#       .headers('Content-Type': 'application/json')
#       .post(data) (err, res, body) ->
#         data = JSON.parse body
#         token = data.auth_token
#         return token

#   # Get all tasks or userstories.
#   robot.hear /taiga (us|userstory|userstories|task|tasks) list/i, (msg) ->
#     project = getProject(msg)
#     if not project
#       msg.send project_not_set_msg
#       return

#     resource_type = msg.match[1]

#     switch resource_type
#       when 'us','userstory','userstories' then resource_path = '/userstories'
#       when 'task','tasks' then resource_path = '/tasks'

#     token = getUserToken(msg)

#     if token
#       getAllResource(msg, token, project, resource_path)
#     else
#       if getBotToken()
#         getAllResource(msg, token, project, resource_path)
#       else
#         msg.send "Unable to authenticate"

#   getAllResource = (msg, token, projectSlug, resource_path) ->
#     if getPID(token, projectSlug)
#       # Get list userstories/tasks for project where status_is_closed=false.
#       data = "?project=#{pid}&status__is_closed=false"
#       robot.http(url + resource_path + data)
#         .headers('Content-Type': 'application/json', 'Authorization': auth)
#         .get() (err, res, body) ->
#           response_list = JSON.parse body

#           if response_list
#             say = ""
#             say += formatted_reponse(item, resource_path) for item in response_list
#             msg.send say

#           else
#             msg.send "Couldn't get data for project with id #{pid}."
#     else
#       msg.send "Couldn't get the pid."

#   formatted_reponse = (item, resource_path) ->
#     words = ""

#     switch resource_path
#       when '/userstories'
#         words += "us:" + item['id'] + " - "
#         words += "*" + item['subject'] + "* "
#         words += "_" + item['status_extra_info']['name'] + "_ "
#         words += "(" + item['assigned_to_extra_info']['full_name_display'] + ")" if item['assigned_to_extra_info']
#         if item['description']
#           words += "\n"
#           words += "_" + item["description"] + "_"
#           words += "\n"
#         else
#           words += "\n"
#       when '/tasks'
#         words += "task:" + item['id'] + " - "
#         words += "*" + item['subject'] + "* "
#         words += "_" + item['status_extra_info']['name'] + "_ "
#         words += "(" + item['assigned_to_extra_info']['full_name_display'] + ")" if item['assigned_to_extra_info']
#         if item['description']
#           words += "\n"
#           words += "_" + item["description"] + "_"
#           words += "\n"
#         else
#           words += "\n"

#     return words


  ##################################################

  # robot.hear /taiga post (\d+.*) (subject:(.*)) (description:(.*))/i, (msg) ->

  #   resource_type = msg.match[1]
  #   incoming_subject = msg.match[3]
  #   incoming_description = msg.match[5]

  #   payload = {
  #     subject: incoming_subject,
  #     description: incoming_description
  #   }

  #   project = getProject(msg)
  #   if not project
  #     msg.send project_not_set_msg
  #     return

  #   token = getUserToken(msg)

  #   if token
  #     postResource(msg, token, project, resource_type, payload)
  #   else
  #     data = JSON.stringify({
  #       type: "normal",
  #       username: username,
  #       password: password
  #     })
  #     robot.http(url + 'auth')
  #       .headers('Content-Type': 'application/json')
  #       .post(data) (err, res, body) ->
  #         data = JSON.parse body
  #         token = data.auth_token
  #         if token
  #           postResource(msg, token, project, resource_type, payload)
  #         else
  #           msg.send "Unable to authenticate"

  # postResource = (msg, token, projectSlug, resource_type, payload) ->
  #   # Use for grabbing resolved project id.
  #   data = "?project=#{projectSlug}"
  #   auth = "Bearer #{token}"

  #   # TODO: settle resource type string.
  #   switch resource_type
  #     when 'us','userstory' then postableUrl = 'userstories', gettableUrl = 'us'
  #     when 'task' then postableUrl = 'tasks', gettableUrl = 'tasks'

  #   # Get project id.
  #   robot.http(url + 'resolver' + data)
  #     .headers('Content-Type': 'application/json', 'Authorization': auth)
  #     .get() (err, res, body) ->
  #       data = JSON.parse body
  #       pid = data.project

  #       # If we resolve the project id.
  #       if pid

  #         # Update payload to include required project id.
  #         payload.project = pid

  #         # Make the object into a string for sending through tubes.
  #         postable_json = JSON.stringify payload

  #         robot.http(url + "/#{resource_type}")
  #           .headers('Content-Type': 'application/json', 'Authorization': auth)
  #           .post(postable_json) (err, res, body) ->
  #             reference = JSON.parse body
  #             if err or not reference.id
  #               msg.send "Failed to create a #{resource_type}."
  #             else
  #               msg.send "Created <#{taiga_tree_url}#{getProject(msg)}/#{gettableUrl}/#{reference.id}|#{subjectable}>."
  #       else
  #         msg.send "Couldn't get the damn pid."







