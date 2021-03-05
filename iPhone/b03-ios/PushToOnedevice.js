
'use strict'

// Translate this
const _ = {
    newPost: "New story posted",
    postedStory: "%s story posted",
    newMessage: "New message",
    newComment: "%s comment your story",
}
// Translate this
const localization = require('./strings')
const notificationTopic = "topic";

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const vsprintf = require('sprintf-js').vsprintf;
admin.initializeApp();

function setTime(snap) {
    // auto-populating the current timestamp
    snap.ref.child("created").set(admin.database.ServerValue.TIMESTAMP);
}

function tags(inputText) {
    var regex = /(?:^|\s)(?:#)([a-zA-Z\d]+)/gm;
    var matches = [];
    var match;

    while ((match = regex.exec(inputText))) {
        matches.push(match[1]);
    }

    console.log("tags founded: " + matches);
    return matches;
}

function lang(user) {
    const ln = user["lang"] | "en";
    console.log("User " + user["name"] + " (" + ln + ")");

    if (localization[ln] != null) {
        return localization[ln];
    } else {
        return localization.en;
    }
}

exports.notify = functions.https.onRequest((req, res) => {
    const user_Id = req.query.userID;

    return admin.database().ref("/users/" + user_Id).once("value", function(snapshot) {
      var user = snapshot.val();
      var payload = {
        notification: {
          title: user_Id,
          body: "Hello"
        },
        topic: notificationTopic + user_Id
      };
      
      if (user != null){
        // user exist
        payload.notification.body = "Hello " + user.name;
      }
      console.log(payload);
      return admin.messaging().send(payload);
    });
});

exports.safeDelete = functions.database.ref('posts/{postId}').onDelete((snap, context) => {
    const deletedData = snap.val(); // data that was deleted
    const storyId = snap.key;

    console.log("Story deleted: " + storyId +  " for user: " + deletedData.user);
    
    var promises = [
        admin.database().ref('/comments/').child(storyId).remove(),
        admin.database().ref('/likes/').child(storyId).remove(),
        admin.database().ref('/recents/').child(storyId).remove(),
        admin.database().ref('/user_feed/' + deletedData.user).child(storyId).remove(),
        admin.database().ref('/uploads/' + deletedData.user).child(storyId).remove(),
        admin.database().ref('/activity/' + deletedData.user).child(storyId).remove()
    ];

    return Promise.all(promises);
});

exports.publish = functions.database.ref('posts/{postId}')
    .onCreate(async (snap, context) => {

    const story = snap.val(); // data that was created
    const storyId = snap.key;

    console.log("save post", storyId, "for user", story.user);

    // update time to current
    setTime(snap);

    // add to recents
    const type = story.type;
    const timestamp = admin.database.ServerValue.TIMESTAMP;
    const textmsg = story.heading;

    admin.database().ref('/recents/').child(storyId).child("timestamp").set(timestamp);

    if (typeof  textmsg !== undefined && textmsg  === textmsg.toString()) {
    admin.database().ref('/recents/').child(storyId).child("textmessage").set(textmsg);
    }
    if (typeof  type !== undefined) {
      admin.database().ref('/recents/').child(storyId).child("type").set(type);
    }

    // personalized collection per user
    admin.database().ref('/user_feed/' + story.user).child(storyId).set(admin.database.ServerValue.TIMESTAMP);

    // filtered collection of uploaded stories per user
    admin.database().ref('/uploads/' + story.user).child(storyId).set(admin.database.ServerValue.TIMESTAMP);

    var user = await admin.database().ref('/users/' + story.user).once('value');
    story.ref.child("userName").set(user.name);

    // add story to followers feed
    var followers = admin.database().ref('/users/' + story.user + '/followers/')
        .once('value').then(function(snapshot) {

        snapshot.forEach(function(childSnapshot) {
            var childKey = childSnapshot.key;
            var childData = childSnapshot.val();
            admin.database().ref('/user_feed/' + childKey).child(storyId).set(admin.database.ServerValue.TIMESTAMP);

            // send push notification to user channel
            var payload = {
                notification: {
                    title: vsprintf(_.postedStory, user.name),
                    body: story.message,
                },
                topic: notificationTopic + childKey
            };

            admin.messaging().send(payload);
        });
    });

    // post notification for admin
    var user = admin.database().ref('/users/' + story.user).once('value').then(function(snapshot) {
        var userID = snapshot.key;
        var user = snapshot.val();

        // send push notification from admin
        if (user.main == true) {
            var payload = {
                notification: {
                    title: _.newPost,
                    body: message
                },
                topic: notificationTopic + userID
            };
        
            return admin.messaging().send(payload);
        }
    });

    return Promise.all([followers, user]);
});

exports.onComments = functions.database.ref('/comments/{postId}/{commentId}')
    .onCreate(async (snap, context) => {

    const storyId = context.params.postId;
    const comment = snap.val();
    setTime(snap);

    console.log(storyId, comment);

    var snapPost = await admin.database().ref('/posts/' + storyId).once('value');
    var story = snapPost.val();
    var message = comment.message;

    // send push notification to user channel
    var payload = {
        notification: {
            title: vsprintf(_.newComment, comment.profile_name),
            body: message,
        },
        data: {
            type: 'comment',
            id: storyId,
        },
        topic: notificationTopic + story.user
    };

    admin.messaging().send(payload)

    // update count and last message
    var commentSnap = await snap.ref.parent.once('value');
    snapPost.ref.update({
        message: message,
        comments: commentSnap.numChildren()
    });
});

exports.onNewLikes = functions.database.ref('/likes/{postId}')
    .onCreate(async (change, context) => {

    const storyId = context.params.postId;
    const uid = context.auth.uid || null;
    var snap_post = await admin.database().ref('/posts/' + storyId).once('value');
    var userId = snap_post.val()["user"];

    if (userId != uid) {
        console.log("User " + uid + " like the post: " + storyId + "(" + userId + ")" );

        var meUserRef = admin.database().ref('/users/' + uid);
        var postUserRef = admin.database().ref('/users/' + userId);

        var snap_me = await meUserRef.once('value');
        var snapUser = await postUserRef.once('value');
        var strings = lang(snapUser.val());
        var name = snap_me.val().name || "";

        var payload = {
            notification: {
                title: vsprintf(strings.newLike, name),
                body: ""
            },
            data: {
                type: 'story',
                id: storyId,
            },
            topic: notificationTopic + userId
        };
        
        admin.messaging().send(payload);
    } else {
        console.log("Liked own post. No hugs send/received.")
    }
});

exports.onLikes = functions.database.ref('/likes/{postId}')
    .onWrite(async (change, context) => {

    const storyId = context.params.postId;
    const uid = context.auth.uid || null;
    const before = change.before;
    const after = change.after;
    const likesCount = change.after.numChildren();

    // get the user of that post
    var snap_post = await admin.database().ref('/posts/' + storyId).once('value')

    // update post likes count
    var post = snap_post.val();
    snap_post.ref.child("likes").set(likesCount);

    // update user total likes
    var userId = post["user"];

    var snap_likes = await admin.database().ref('/users/' + userId + '/liked').once('value')
    var count = snap_likes.val() || 0;
    var max = 99999999; // max trend

    if (!after.exists()) { // it's deleted. so disliked
        snap_likes.ref.set(count - 1); // -1 score
        snap_likes.ref.parent.child("trend").set(max-count+1);
    } else { // it's created. so liked
        snap_likes.ref.set(count + 1); // +1 score
        snap_likes.ref.parent.child("trend").set(max-count-1);
    }
});

exports.onMessage = functions.database.ref('/messages/{chatId}/{messageId}')
    .onCreate(async (snap, context) => {

    const message = snap.val();
    const chatId = context.params.chatId;
    setTime(snap);

    console.log("New message for :", chatId, message);

    // get chat
    var chat = await admin.database().ref("chats")
        .child(message["user_id"])
        .child(chatId).once('value');
    chat.ref.child("updated").set(admin.database.ServerValue.TIMESTAMP);
    var contactId = chat.val().contact;

    // update contact total unread counter
    const contact = await admin.database().ref('users').child(contactId).once('value');
    var unread = contact.val()["unread"] | 0
    unread = unread + 1;
    // increment unter
    contact.ref.update({ unread: unread });

    // update name
    chat.ref.update({ name: contact.val().name });

    // update contact chat unread counter
    const chat2 = await admin.database().ref("chats").child(contactId).child(chatId).once('value');
    var unread = chat2.val()["unread"] | 0
    unread = unread + 1;

    const me = await admin.database().ref('users').child(message["user_id"]).once('value');
    var name = me.val()["name"];

    // increment counter
    chat2.ref.update({ unread: unread, name: name });
    const deviceTokenRef = await admin.database().ref('device_token').child(contactId).once('value');

    var strings = lang(contact.val());
    var payload = {
        notification: {
            title: vsprintf(strings.newMessage, name),
            body: message.message
        },
        data: {
            type: 'chat',
            id: chatId,
        },
        topic: notificationTopic + contactId,
        token: deviceTokenRef
    };

    console.log(payload);

              
    admin.messaging().send(payload);
});

// exports.userInit = functions.database.ref('/messages/{chatId}/{messageId}')
//     .onCreate(async (snap, context) => {
//     // new user registered
// });
