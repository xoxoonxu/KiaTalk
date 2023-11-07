import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/chatting/chat/message.dart';
import 'package:flutterapp/chatting/chat/new_message.dart';
import 'package:flutterapp/config/palette.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutterapp/config/match.dart';

class ChatScreen extends StatefulWidget{
  const ChatScreen({Key? key}):super(key:key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final _authentication = FirebaseAuth.instance;
  final Match _matchInstance = Match();
  User? loggedUser;
  final String ranking = 'https://m.sports.naver.com/kbaseball/record/index';
 // String match = _matchInstance.getMatchForToday();
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
          onTap: () async {
            String matchLink = await _matchInstance.getMatchLink();
            if(matchLink=='경기 없음')
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title:Text('경기없음'),
                    content: Text('오늘 경기 기록이 없습니다.'),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('확인'),
                      )
                    ],
                  );
                }
              );
            else{
              naversports = 'https://m.sports.naver.com/game/'+matchLink+DateTime.now().year.toString()+'/record';
              launch(naversports);
            }

          },
          child: FutureBuilder<String>(
            future: _matchInstance.getMatchForToday(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('로딩 중...'); // 또는 로딩 인디케이터
              } else if (snapshot.hasError) {
                return Text('에러: ${snapshot.error}');
              } else {
                return Text(snapshot.data ?? '');
              }
            },
          ),
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