import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/chatting/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key?key}):super(key:key);


  @override
  Widget build(BuildContext context) {
    //현재 사용자가져오기
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic>? data = chatDocs[index].data() as Map<String, dynamic>?;
            // 필드가 존재하는지 확인 후 값에 접근
            final String text = data?['text'] ?? '';
            final bool isCurrentUser = data?['userID'].toString() == user!.uid;
            final String userName = data?['userName'] ?? '';
            final Timestamp time = data?['time'] ?? Timestamp.now();
            final String? imageUrl = data?['url'];
              return ChatBubbles(text,
                  isCurrentUser,
                  userName,
                  time,
                  imageUrl ?? ''
              );
          },
        );
      },
    );
  }
}