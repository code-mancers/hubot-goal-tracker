db = exports

Url    = require "url"
cradle = require "cradle"
info   = Url.parse process.env.HUBOT_COUCHDB_URL || 'http://localhost:5984'
if info.auth
  auth = info.auth.split(":")
  client = new(cradle.Connection) info.hostname, info.port, auth:
    username: auth[0]
    password: auth[1]
else
  client = new(cradle.Connection)(info.hostname, info.port)

db.instance = client.database(if info.pathname != '/' then info.pathname.slice(1) else "goal_tracker")

db.setupDB = (dbInstance) ->
  dbInstance.exists  (err, exists) ->
    if (err)
      console.log('error', err)
    else if (exists)
      console.log('Database exists, good to go')
    else
      console.log('Database does not exist. Creating one.')
      dbInstance.create()

  dbInstance.save '_design/goals',
    byUser:
      map: (doc) ->
        emit(doc.user, doc) if doc.user
