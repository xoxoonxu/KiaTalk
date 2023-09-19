import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/config/palette.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:intl/intl.dart';
class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message,this.isMe,this.userName,this.time,{super.key});

  final String message;
  final String userName;
  final Timestamp time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if(isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,5,0),
            child: ChatBubble(
              clipper: ChatBubbleClipper9(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Palette.activeColor,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Palette.textColor2
                    ),
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(time.toDate()),
                      style:TextStyle(color: Colors.grey),

                    )
                  ],
                ),
              ),
            ),
          ),
        if(!isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(5,0,0,0),
            child: ChatBubble(
              clipper: ChatBubbleClipper9(type: BubbleType.receiverBubble),
              backGroundColor: Palette.textColor2,
              margin: EdgeInsets.only(top: 20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,color:Palette.activeColor
                    ),
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(time.toDate()),
                      style: TextStyle(color:Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          )

      ],
    );
  }
}
