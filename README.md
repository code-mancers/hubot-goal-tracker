hubot-goal-tracker
==================

A hubot script that lets you create and track your goals

### Configuration:
    # CouchDB API endpoint
    HUBOT_COUCHDB_URL=http://USERNAME:PASSWORD@couchdb.domain.com:5984
    # OR the following if you want to use a different database named 'my_db'
    HUBOT_COUCHDB_URL=http://USERNAME:PASSWORD@couchdb.domain.com:5984/my_db

    # Notification Room ID if you want to broadcast goal related activities
    # For HipChat this is the XMPP JID of the room
    HUBOT_GOAL_TRACKER_ROOM=<ROOM_ID>

### Commands:
    hubot add goal "<GOAL>" # adds a goal for the weekend. (quotes required!)
    hubot goals # shows pending goals
    hubot goal <GOAL_ID> done # marks goal with id = GOAL_ID as done

### Development :
If couchdb is running locally on localhost:5984, you don't need to set
HUBOT_COUCHDB_URL.

#### Testing on HipChat
Set up a test account, add a test bot user and a test room and use the command:

    HUBOT_HIPCHAT_JID=1234@chat.hipchat.com HUBOT_HIPCHAT_PASSWORD=password HUBOT_GOAL_TRACKER_ROOM=1234_room@conf.hipchat.com bin/hubot -a hipchat

This should make your bot user join all your rooms. You can test the bot using
hipchat like you normally would.
