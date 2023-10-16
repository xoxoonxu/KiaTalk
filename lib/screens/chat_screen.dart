import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/chatting/chat/message.dart';
import 'package:flutterapp/chatting/chat/new_message.dart';
import 'package:flutterapp/config/palette.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
class ChatScreen extends StatefulWidget{
  const ChatScreen({Key? key}):super(key:key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  final String ranking = 'https://m.sports.naver.com/kbaseball/record/index';

  String naversports = '';
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
        title: InkWell(
          onTap: () {
            naversports = 'https://m.sports.naver.com/game/'+DateFormat('yyyyMMdd').format(DateTime.now())+'NCHT'+'0'+DateTime.now().year.toString()+'/record';
            launch(naversports);
            // 여기에 Chat screen을 터치할 때 실행할 코드를 추가하세요.
            print('Chat screen을 터치했습니다.');
          },
          child: Text('Chat screen'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.bar_chart,
              color: Colors.white,
            ),
            onPressed: (){
              launch(ranking);
            },
          ),
          IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ),
            onPressed: (){
                _authentication.signOut();
            },
          ),
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