import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/config/palette.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:intl/intl.dart';
import 'package:flutterapp/screens/full_size_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatBubbles extends StatelessWidget {
  //const ChatBubbles(this.message,this.isMe,this.userName,this.time,{super.key});
  const ChatBubbles(this.message, this.isMe, this.userName, this.time, this.imageUrl,{Key? key}) : super(key: key);

  final String message;
  final String? imageUrl; //10월16일
  final String userName;
  final Timestamp time;
  final bool isMe;

  //url인지 확인하는 함수

  bool isURL(String text) {
    // URL 정규 표현식
    final urlPattern = RegExp(
      r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );

    return urlPattern.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap:(){
        if (imageUrl!=null&& imageUrl!.isNotEmpty){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>FullSizeImage(imageUrl!),
            ),
          );
        }
        else if(imageUrl! == ''&&message.isNotEmpty&&(isURL(message))==true)
          try {
            launch(message);
          } catch (e) {
            print('URL 실행 중 오류: $e');
          }
      },
      child: Row(
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
                      if(imageUrl != null && imageUrl!.isNotEmpty)
                        Image.network(
                          imageUrl!,
                          width: MediaQuery.of(context).size.height * 0.4, // 이미지의 적절한 너비 설정
                          height: MediaQuery.of(context).size.height * 0.3, // 이미지의 적절한 높이 설정
                          fit: BoxFit.fitWidth,
                        ),



                      if(imageUrl! == '')
                        if(message.isNotEmpty && !isURL(message))
                          Text(
                            message,
                            style:TextStyle(color:Colors.white),
                          ),
                      if(imageUrl! == '')
                        if(message.isNotEmpty && isURL(message))
                          Text(
                            message,
                            style:TextStyle(color:Colors.blue),
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
                      if(imageUrl != null&& imageUrl!.isNotEmpty)
                        Image.network(
                          imageUrl!,
                          width: MediaQuery.of(context).size.height * 0.4, // 이미지의 적절한 너비 설정
                          height: MediaQuery.of(context).size.height * 0.3, // 이미지의 적절한 높이 설정
                          fit: BoxFit.fitWidth,
                        ),

                      if (message.isNotEmpty&& imageUrl! == ''&& !isURL(message)) // 텍스트 메시지가 있는 경우
                        Text(
                          message,
                          style: TextStyle(color: Colors.white),
                        ),
                      if (message.isNotEmpty&& imageUrl! == ''&& isURL(message)) // 텍스트 메시지가 있는 경우
                        Text(
                          message,
                          style: TextStyle(color: Colors.blue),
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
      ),
    );
  }
}
