import 'package:flutter/material.dart';
import 'package:flutterapp/screens/chat_screen.dart';
import 'package:flutterapp/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //firebase_core 초기화 어쩌구
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}):super(key:key);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'Chat',
      theme: ThemeData(primarySwatch: Colors.blue), //ThemeData
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ChatScreen();
          }
          return LoginSignupScreen();
        },
      ),
    );
  }
}
