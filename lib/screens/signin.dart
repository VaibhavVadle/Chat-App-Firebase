import 'package:chat_app_demo/screens/chat_room_screen.dart';
import 'package:chat_app_demo/screens/signup.dart';
import 'package:chat_app_demo/services/auth.dart';
import 'package:chat_app_demo/services/database.dart';
import 'package:chat_app_demo/services/shared_preference.dart';
import 'package:chat_app_demo/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  signIn() {
    if (_formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmail(emailController.text);
      // HelperFunctions.saveUserName(usernameController.text);

      setState(() {
        isLoading = true;
      });

      dataBaseMethods.getUserByUserEmail(emailController.text).then((value) {
        snapshotUserInfo = value;
        HelperFunctions.saveUserEmail(snapshotUserInfo!.docs[0]['email']);
        HelperFunctions.saveUserName(snapshotUserInfo!.docs[0]['name']);
      });

      AuthMethods()
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        setState(() {
          isLoading = false;
        });

        if (value != null) {
          HelperFunctions.saveUserLogin(true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomScreen(),
              ));
        }
      });
    }
  }

  signInGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await FirebaseAuth.instance.signInWithCredential(authCredential);
        print('emailID: ${googleSignInAccount.displayName}');
        Map<String, String> userInfoMap = {
          'name': googleSignInAccount.displayName.toString(),
          'email': googleSignInAccount.email.toString(),
        };
        dataBaseMethods.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatRoomScreen(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      print('Error ${e.message}');
    }
  }

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        title: const Text('Chat App Demo'),
        centerTitle: true,
      ),
      body: isLoading
          ? const SafeArea(child: Center(child: CircularProgressIndicator()))
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTextFormField(
                          text: 'Email',
                          controller: emailController,
                          validator: (value) =>
                              Validation.emailValidation(value!),
                        ),
                        const SizedBox(height: 20),
                        buildTextFormField(
                          text: 'Password',
                          obscureText: !passwordVisible,
                          controller: passwordController,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white),
                          ),
                          validator: (value) =>
                              Validation.passwordValidation(value!),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: signIn,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: signInGoogle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            width: MediaQuery.of(context).size.width,
                            child: const Text(
                              "Sign In with Google",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ));
                              },
                              child: const Text(
                                "Register now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50)
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  TextFormField buildTextFormField({
    String? text,
    TextEditingController? controller,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: text,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
