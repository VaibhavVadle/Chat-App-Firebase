import 'package:chat_app_demo/constants.dart';
import 'package:chat_app_demo/screens/conversation_screen.dart';
import 'package:chat_app_demo/screens/search_screen.dart';
import 'package:chat_app_demo/screens/signin.dart';
import 'package:chat_app_demo/services/auth.dart';
import 'package:chat_app_demo/services/database.dart';
import 'package:chat_app_demo/services/shared_preference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  Stream<QuerySnapshot> chatRoomStream =
      FirebaseFirestore.instance.collection('ChatRoom').snapshots();

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      chatroomId: snapshot.data!.docs[index]['chatroomId'],
                      userName: snapshot.data!.docs[index]['chatroomId']
                          .toString()
                          .replaceAll('_', '')
                          .replaceAll(Constants.myName, ''));
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserName())!;
    dataBaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    // setState(() {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade800,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ));
            },
            child: const Icon(Icons.search)),
        appBar: AppBar(
          title: const Text('Chat App'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    AuthMethods().signOut().then((value) async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                          (route) => false);
                    });
                  });
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: chatRoomsList());
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatroomId;

  const ChatRoomTile(
      {required this.chatroomId, required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ConversationScreen(
              chatRoomID: chatroomId,
              userName: userName,
            );
          },
        ));
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
