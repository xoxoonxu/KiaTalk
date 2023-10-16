import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        // 비밀번호 재설정 이메일을 성공적으로 보냈다면 여기에 원하는 동작을 추가할 수 있습니다.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("비밀번호 재설정 이메일을 보냈습니다. 이메일을 확인해주세요."),
          ),
        );
      } catch (e) {
        print("비밀번호 재설정 이메일 보내기 오류: $e");
        // 이메일 보내기 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("비밀번호 재설정 이메일을 보내는 중 오류가 발생했습니다."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("비밀번호 재설정"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "이메일",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이메일을 입력하세요.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _sendPasswordResetEmail,
                child: Text("비밀번호 재설정 이메일 보내기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}