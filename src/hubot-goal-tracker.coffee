# Description:
#   Goal tracker
#
# Dependencies:
#   "cradle": "0.6.3"
#
# Configuration:
#   HUBOT_COUCHDB_URL
#   HUBOT_GOAL_TRACKER_ROOM
#
# Commands:
#   hubot add goal "<GOAL>" - adds a goal for the weekend. (quotes required!)
#   hubot goals - shows pending goals
#   hubot goal <GOAL_ID> done - marks goal with id = GOAL_ID as done
#
# Author:
#   emilsoman
#
# Notes:
#   If couchdb is not running on localhost:5984, you need to set an ENV var
#   HUBOT_COUCHDB_URL.
#
#   If you want to broadcast events to a notification room, set the Room id
#   (that's the room's XMPP JID for HipChat) in ENV var HUBOT_GOAL_TRACKER_ROOM

db = require './db'
db.setupDB(db.instance)
room_jid = process.env.HUBOT_GOAL_TRACKER_ROOM

module.exports = (robot) ->

  # Respond to "add goal <GOAL>" by adding the goal to the DB
  robot.respond /add goal "(.*)"/i, (msg) ->
    user = msg.message.user.name
    goal = msg.match[1]

    doc =
      timestamp: Date.now()
      user: user
      goal: goal

    db.instance.save doc, (err, res) ->
      if err then console.error(err)

    robot.messageRoom room_jid, "#{user} added goal: '#{goal}'"

  # Respond to "goals" with
  # "<GOAL_ID>: <GOAL>"
  robot.respond /goals/i, (msg) ->
    user = msg.message.user.name

    db.instance.view 'goals/byUser', {key: user}, (err, goals) ->
      message = ""
      for goal in goals
        status = goal.value.status
        statusText = if status then " is #{status}" else ""
        message += "#{goal.id}: '#{goal.value.goal}'#{statusText}\n"
      msg.send message

  # Respond to "goal <GOAL_ID> done" by marking it's status as "DONE" in DB
  robot.respond /goal (\S+) done/i, (msg) ->
    user = msg.message.user.name
    docId = msg.match[1]

    db.instance.get docId, (err, doc) ->
      doc.status = 'DONE'
      db.instance.save docId, doc, (err, res) ->
        if err
          console.error(err)
        else
          robot.messageRoom room_jid, "#{user} completed goal '#{doc.goal}'"
          msg.send "Got it. '#{doc.goal}' is #{doc.status}. Good job!"
