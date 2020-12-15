import 'package:chatter/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DBmethods {
  getUsers(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get();
  }

  getUserwithEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  uploadUserInfo(userMap, uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createChat(String roomId, chatMap) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .set(chatMap)
        .catchError((e) => {print(e)});
  }

  getMessages(String roomId) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  getRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .where('users', arrayContains: userName)
        .snapshots();
  }

  getChannel(String serverId) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .doc(serverId)
        .snapshots();
  }

  getChannelMsgs(String channelName, String serverId) async {
    if (Constants.roomName != null) {
      return await FirebaseFirestore.instance
          .collection('rooms')
          .doc(serverId)
          .collection(channelName)
          .orderBy('timestamp', descending: false)
          .snapshots();
    }
  }

  addMessage(String roomId, String channelName, messageMap) async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection(channelName)
        .add(messageMap)
        .catchError(
          (e) => {
            print(e.code.toString()),
          },
        );
  }

  addServer(String roomId, serverMap) async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .set(serverMap)
        .catchError(
          (e) => {
            print(e.code.toString()),
          },
        );
  }

  getAllRooms() async {
    return await FirebaseFirestore.instance.collection('rooms').snapshots();
  }

  addUser(String userName, String roomId) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .update(
      {
        "users": FieldValue.arrayUnion([userName]),
      },
    );
  }

  leaveServer(String roomId, String userName) async {
    return await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .update(
      {
        'users': FieldValue.arrayRemove([userName]),
      },
    );
  }
}
