import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/chatting/chat/message.dart';
import 'package:flutterapp/chatting/chat/new_message.dart';
import 'package:flutterapp/config/palette.dart';
class ChatScreen extends StatefulWidget{
  const ChatScreen({Key? key}):super(key:key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.activeColor,
        title: Text('Chat screen'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ),
            onPressed: (){
                _authentication.signOut();
            },
          )
        ]
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      )
    );
  }
}