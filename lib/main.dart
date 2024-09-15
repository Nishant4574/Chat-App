
import 'package:chat_app/pages/ChatPage.dart';
import 'package:chat_app/pages/ForgotPassword.dart';
import 'package:chat_app/pages/HomePage.dart';
import 'package:chat_app/pages/SignUp.dart';
import 'package:chat_app/pages/Signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',


      home:Signin()
    );
  }
}

