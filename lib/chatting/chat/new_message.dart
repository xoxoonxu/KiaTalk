import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? pickedIamge;


  Future<String> _uploadImage(File image) async {
    Reference storageReference =
    FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => print('이미지 업로드 완료'));

    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  // Future<void> _saveImageUrlToFirestore(String imageUrl) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference images = firestore.collection('chat');
  //
  //   await images.add({'url': imageUrl});
  // }

  Future<void> _pickImage() async{
  // 갤러리에서 이미지 선택
  final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
  setState(() {
    if(pickedFile !=null){
      pickedIamge = File(pickedFile.path);
    }

  });


  if (pickedFile != null) {
    String imageUrl = await _uploadImage(pickedIamge!);
    //await _saveImageUrlToFirestore(imageUrl);
  // 선택된 이미지 경로 출력 및 처리 로직 수행 (예: 이미지 전송)
  print("선택된 이미지: ${pickedFile.path}");
  final user = FirebaseAuth.instance.currentUser;
  final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
  FirebaseFirestore.instance.collection('chat').add({
    'text' : _userEnterMessage,
    'time' : Timestamp.now(),
    'userID': user!.uid,
    'userName' : userData.data()!['userName'],
    'url' : imageUrl,
  });
  // 선택된 이미지를 처리하는 로직을 여기에 추가하세요.
  } else {
  // 이미지가 선택되지 않았을 때
  print("이미지가 선택되지 않았습니다.");
  }
}



  var _userEnterMessage = '';
  void _sendMessage()async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text' : _userEnterMessage,
      'time' : Timestamp.now(),
      'userID': user!.uid,
      'userName' : userData.data()!['userName'],
      'url': '',
    });
    _controller.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(onPressed: _pickImage,
              icon: Icon(Icons.image)),
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Palette.activeColor,
          ),
        ],
      ),
    );
  }
}