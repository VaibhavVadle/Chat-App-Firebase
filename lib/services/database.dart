import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance
        .collection('users')
        .add(userMap)
        .catchError((e) => print('error : ${e.toString()}'));
  }

  createChatRoom(String? chatRoomId, charRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(charRoomMap)
        .catchError((e) {
      print('error : ${e.toString()}');
    });
  }

  addConversationMessages(String chatRoomID, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print('error : ${e.toString()}');
    });
  }

  getConversationMessages(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
