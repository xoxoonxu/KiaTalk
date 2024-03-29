import 'package:flutter/material.dart';
import 'package:flutterapp/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/screens/chat_screen.dart';
import 'package:flutterapp/screens/findPassword.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(); // GoogleSignIn 인스턴스 생성
  bool isSignupScreen = true;
  bool showSpinner =false;

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }
  Future<User?> _handleSignIn() async{
    try{
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if(googleUser == null){
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult = await _authentication.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    }catch(error){
      print(error);
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [

              Positioned(top: 0,
                  right: 0,
                  left: 0,
                  child:Container(
                    height:MediaQuery.of(context).size.height*0.4,
                    decoration: BoxDecoration(
                        image:DecorationImage(
                            image: AssetImage('image/kiatigers.png'),
                            fit:BoxFit.fill
                        )
                    ),
                  )),
              //배경

              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: MediaQuery.of(context).size.height*0.4,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20.0),
                  height: isSignupScreen ? MediaQuery.of(context).size.height*0.3 : MediaQuery.of(context).size.height*0.25,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom:20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: !isSignupScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1),
                                  ),
                                  if (!isSignupScreen)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Palette.textColor2,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'SIGNUP',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSignupScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1),
                                  ),
                                  if (isSignupScreen)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Palette.textColor2,
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                        if(isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Form(
                              key:_formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key:ValueKey(1),
                                    validator: (value){
                                      if(value!.isEmpty || value.length<4){
                                        return 'Please enter at least 4 characters';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userName=value!;
                                    },
                                    onChanged: (value){
                                      userName = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'User name',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key:ValueKey(2),
                                    validator: (value){
                                      if(value!.isEmpty||!value.contains('@')){
                                        return 'Please enter a valid email address!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userEmail=value!;
                                    },
                                    onChanged: (value){
                                      userEmail = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'email',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key:ValueKey(3),
                                    validator: (value){
                                      if(value!.isEmpty||value.length<6){
                                        return 'Password must be at least 7 characters long.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userPassword=value!;
                                    },
                                    onChanged: (value){
                                      userPassword = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'password',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        if(!isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key:ValueKey(4),
                                    validator: (value){
                                      if(value!.isEmpty||!value.contains('@')){
                                        return 'Please enter a valid email address!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userEmail=value!;
                                    },
                                    onChanged: (value){
                                      userEmail=value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'email',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key:ValueKey(5),
                                    validator: (value){
                                      if(value!.isEmpty || value.length<6){
                                        return 'Password must be at least 7 characters long';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userPassword=value!;
                                    },
                                    onChanged: (value){
                                      userPassword=value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Palette.textColor1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'password',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Palette.textColor1),
                                        contentPadding: EdgeInsets.all(10)),
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              //텍스트 폼 필드


              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen ? MediaQuery.of(context).size.height*0.65 : MediaQuery.of(context).size.height*0.6,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: GestureDetector(
                      onTap:() async{
                        setState(() {
                          showSpinner=true;
                        });
                        if(isSignupScreen){
                          _tryValidation();

                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                                email: userEmail,
                                password: userPassword,
                            );
                            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid).set({
                              'userName' : userName,
                              'email' : userEmail
                            });
                            if(newUser.user !=null){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                return ChatScreen();
                              }
                              ),
                              );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }catch(e){
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                Text('Please check your email and password'),
                                backgroundColor: Colors.blue,
                                ),
                            );
                          }
                        }
                        if(!isSignupScreen){
                          _tryValidation();
                          try {
                            final newUser =
                            await _authentication.signInWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            if (newUser.user != null) {
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatScreen();
                                  },
                                ),
                              );*/
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }catch(e){
                            String errorMessage = "로그인 중 오류가 발생했습니다.";
                            if (e is FirebaseAuthException) {
                              switch (e.code) {
                                case 'user-not-found':
                                  errorMessage = '이메일이 올바르지 않습니다.';
                                  break;
                                case 'wrong-password':
                                  if(userEmail.contains("gmail"))
                                    errorMessage = '아래에 구글 로그인 버튼을 눌러주세요';
                                  else
                                    errorMessage = '비밀번호가 올바르지 않습니다.';
                                  break;
                                default:
                                  errorMessage = '로그인 중 오류가 발생했습니다.';
                                  break;
                              }
                            }
                            setState(() {
                              showSpinner = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("로그인 오류"),
                                  content: Text(errorMessage),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("확인"),
                                    )
                                  ]
                                );
                              }

                            );
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Palette.activeColor,Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //전송버튼

              //비밀번호 찾기 버튼 구현

              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen ? MediaQuery.of(context).size.height - 120:MediaQuery.of(context).size.height - 160,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(isSignupScreen ? 'or Signup with' : 'or Signin with'),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: () async{
                        setState(() {
                          showSpinner=true;
                        });
                        try{
                          if(isSignupScreen){
                            //구글로그인 버튼 클릭시
                            final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                            if(googleUser ==null){
                              //사용자가 구글 로그인을 취소한 경우
                              setState(() {
                                showSpinner = false;
                              });
                              return;
                            }
                            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                            final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken,
                            );
                            final UserCredential authResult = await _authentication.signInWithCredential(credential);
                            final User? user = authResult.user;
                            if(user != null){
                              //구글 로그인 성공시
                              //Firebase CloudFirestore'user'컬렉션에 사용자 정보 저장
                              await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
                                'userName' : user.displayName,
                                'email':user.email
                              });
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return ChatScreen();
                                }
                                ),
                              );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                            else{
                              //구글 로그인 실패시
                            }
                            setState(() {
                              showSpinner = false;
                            });

                          }
                          else{
                            //로그인 화면일 경우
                            final user = await _handleSignIn();
                            if(user != null){
                              //로그인 성공
                              final userQuery = await FirebaseFirestore.instance.collection('user').where('email',isEqualTo: user.email).get();
                              if (userQuery.docs.isEmpty) {
                                // 동일한 이메일을 가진 사용자가 없는 경우에만 Firestore에 저장
                                await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
                                  'userName': user.displayName,
                                  'email': user.email
                                });
                              }
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return ChatScreen();
                                }
                                ),
                              );
                              setState(() {
                                showSpinner = false;
                              });
                            }

                          }
                        } catch(error){
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Google Sign-in failed'),backgroundColor: Colors.red,)
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: Size(155, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          backgroundColor: Palette.googleColor
                      ),
                      icon: Icon(Icons.add),
                      label: Text('Google'),
                    ),
                  ],
                ),
              ),
              //구글 로그인 버튼

            ],
          ),
        ),
      ),
    );
  }
}