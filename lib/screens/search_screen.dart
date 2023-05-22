import 'package:chat_app_demo/constants.dart';
import 'package:chat_app_demo/screens/conversation_screen.dart';
import 'package:chat_app_demo/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_utils/flutter_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController = TextEditingController();

  DataBaseMethods dataBaseMethods = DataBaseMethods();

  QuerySnapshot? searchSnapshot;

  initiateSearch() {
    dataBaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });

      // print('Snapshot :${searchSnapshot.toString()}');
    });
  }

  createChatRoomAndStartConversation(String userName) {
    print('def: $userName ${Constants.myName.toString()}');
    String chatRoomId = getchatRoomId(userName, Constants.myName);
    List<String?> users = [userName, Constants.myName];

    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatroomId': chatRoomId
    };
    dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatRoomID: chatRoomId,
            userName: userName,
          ),
        ));
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              // print('abc : ${searchSnapshot!.docs[index]}');
              // return null;
              return searchTile(
                userEmail: searchSnapshot!.docs[index]['email'],
                userName: searchSnapshot!.docs[index]['name'],
              );
            },
          )
        : Container();
  }

  Widget searchTile({String? userName, String? userEmail}) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    userEmail!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                    onPressed: () {
                      createChatRoomAndStartConversation(userName);
                    },
                    child: const Text('Message')),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              // ScreenUtil().setVerticalSpacing(50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ]),
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: searchTextEditingController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: 'Search username...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                      )),
                      IconButton(
                          onPressed: initiateSearch,
                          icon: const Icon(
                            CupertinoIcons.search,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              searchList(),
            ],
          ),
        ),
      ),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   final String userName;
//   final String userEmail;
//   const SearchTile(
//       {super.key, required this.userEmail, required this.userName});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     userName,
//                     style: const TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                   Text(
//                     userEmail,
//                     style: const TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               SizedBox(
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                         shape: MaterialStatePropertyAll(RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30)))),
//                     onPressed: () {
//                       createChatRoomAndStartConversation(context: context, userName: )
//                     },
//                     child: const Text('Message')),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

getchatRoomId(String? a, String? b) {
  if (a!.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
