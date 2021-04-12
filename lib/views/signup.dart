import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helper/helperFutions.dart';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/databases.dart';
import 'package:myapp/views/chatRoomsScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  SignUpPage_State createState() => SignUpPage_State();
}

class SignUpPage_State extends State<SignUp> {
  bool _showpass = false;
  bool isloading = false;
  AuthMethods authMethods = new AuthMethods();
  databaseMethods _databaseMethod = new databaseMethods();
  final formkey = GlobalKey<FormState>();
  TextEditingController _userController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  SignMeUp() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (formkey.currentState.validate()) {
          // ignore: non_constant_identifier_names
          Map<String, String> UserInforMap = {
            "name": _userController.text,
            "email": _emailController.text,
          };

          helperFunctions.saveuserEmailSharePreference(_emailController.text);
          helperFunctions.saveuserNameSharePreference(_userController.text);

          setState(() {
            isloading = true;
          });
          authMethods
              .signUpWithEmailAndPassword(
                  _emailController.text, _passController.text)
              .then((val) {
            helperFunctions.saveuserLoggedInSharePreference(true);
            _databaseMethod.UploadUserInfor(UserInforMap);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatRoom()));
          });
        }
      }
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Thông báo",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text("Không có kết nối Internet vui lòng kiểm tra lại"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            );
          });
    }
  }

  Future<void> performLogin() async {
    UserCredential user = await authMethods.signInWithGoogle();

    if (user != null) {
      authenticateUser(user);
    }
  }

  Future<void> authenticateUser(UserCredential user) async {
    authMethods.authenticateUser(user).then((isNewUser) {
      setState(() {});

      if (isNewUser) {
        authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ChatRoom();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ChatRoom();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          actions: <Widget>[
            IconButton(
                icon: Icon(null),
                onPressed: () {
                  print('you pressed Add');
                })
          ],
        ),
        body: isloading
            ? Container(
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                )),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.cyanAccent, Colors.pink])))
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.cyanAccent, Colors.pink])),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Center(
                            child: Container(
                              width: 150,
                              height: 150,
                              padding: EdgeInsets.all(1),
                              child: Image.asset('assets/images/img_logo.png'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              validator: (val) {
                                return val.isEmpty || val.length < 2
                                    ? "tplease provide avalid username"
                                    : null;
                              },
                              controller: _userController,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10)),
                                  ),
                                  hintText: 'Enter your User'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "please provide avalid emailid";
                              },
                              controller: _emailController,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10)),
                                  ),
                                  hintText: 'Enter your email'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Stack(
                                alignment: AlignmentDirectional.centerEnd,
                                children: <Widget>[
                                  TextFormField(
                                    validator: (val) {
                                      return val.length > 6
                                          ? null
                                          : "please provide password 6+ password ";
                                    },
                                    controller: _passController,
                                    obscureText: !_showpass,
                                    decoration: InputDecoration(
                                        hoverColor: Colors.white,
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(10)),
                                        ),
                                        hintText: 'Enter your Password'),
                                  ),
                                  GestureDetector(
                                    onTap: onToggleshowPass,
                                    child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 8, 0),
                                        child: Text(_showpass ? "HIDE" : "SHOW",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                ]),
                          ),
                          Center(
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () {
                                // SignMeUp();
                              },
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'SignUp',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              color: Colors.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                            ),
                          ),
                          Center(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 25, 0, 10),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: () {
                                  performLogin();
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      'SignUp with Google',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                color: Colors.white,
                                textColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                              ),
                            ),
                          )),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Center(
                              child: Text(
                                "Already have account? SignIn now",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void onToggleshowPass() {
    setState(() {
      _showpass = !_showpass;
    });
  }
}
