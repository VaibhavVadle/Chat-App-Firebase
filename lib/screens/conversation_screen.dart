import 'package:chat_app_demo/constants.dart';
import 'package:chat_app_demo/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomID;
  final String userName;

  const ConversationScreen({
    super.key,
    required this.userName,
    required this.chatRoomID,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController messageController = TextEditingController();

  Stream<QuerySnapshot> chatMessagesStream =
      FirebaseFirestore.instance.collection('chats').snapshots();

  Widget chatMessagesList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data!.docs[index]['message'],
                      isSendByMe: snapshot.data!.docs[index]['sendBy'] ==
                          Constants.myName);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sendBy': Constants.myName,
        'time': FieldValue.serverTimestamp(),
      };
      dataBaseMethods.addConversationMessages(widget.chatRoomID, messageMap);
      messageController.text = '';
    }
  }

  @override
  void initState() {
    dataBaseMethods.getConversationMessages(widget.chatRoomID).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        title: Text(widget.userName,
            style: const TextStyle(fontSize: 20, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff007EF4), Color(0xff2A75BC)])),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: chatMessagesList()),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, top: 5, bottom: 5, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white),
                  color: Colors.transparent,
                  // gradient: LinearGradient(
                  //     colors: [Color(0x1AFFFFFF), Color(0x1AFFFFFF)]),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: 'Message...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none),
                    )),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(
                          CupertinoIcons.paperplane,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile(
      {required this.isSendByMe, required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: isSendByMe ? 0 : 15,
        right: isSendByMe ? 15 : 0,
      ),
      margin: isSendByMe
          ? const EdgeInsets.only(top: 8, bottom: 8, left: 60)
          : const EdgeInsets.only(top: 8, bottom: 8, right: 60),
      // margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)])),
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
