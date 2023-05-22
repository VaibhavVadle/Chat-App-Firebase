import 'package:chat_app_demo/screens/chat_room_screen.dart';
import 'package:chat_app_demo/screens/signin.dart';
import 'package:chat_app_demo/services/shared_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool userIsLoggedIn = false;

  // @override
  // void initState() {
  //   getLoggedInStatus();
  //   super.initState();
  // }

  // getLoggedInStatus() async {
  //   await HelperFunctions.getUserLogin().then((value) {
  //     setState(() {
  //       userIsLoggedIn = value!;
  //     });
  //   });
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blueGrey,
      // ),
      home: FirebaseAuth.instance.currentUser == null
          ? const SignInScreen()
          : const ChatRoomScreen(),
    );
  }
}
