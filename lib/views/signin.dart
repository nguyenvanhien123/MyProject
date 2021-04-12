import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';
import 'package:myapp/services/auth.dart';
import 'package:myapp/services/databases.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _showpass = false;
  final formkey = GlobalKey<FormState>();
  databaseMethods _databasemethods = new databaseMethods();
  AuthMethods _authMethods = new AuthMethods();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  bool isLoading = false;
  // signIn() {
  //   if (formkey.currentState.validate()) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     _authMethods
  //         .signInWithEmailAndPassword(
  //             _emailController.text, _passController.text)
  //         .then((Value) async {
  //       if (Value != null) {
  //         QuerySnapshot querySnapshotInfor =
  //             await databaseMethods().getUserInfo(_emailController.text);
  //         await databaseMethods().getUserInfo(_emailController.text);
  //         helperFunctions.saveuserLoggedInSharePreference(true);
  //         helperFunctions.saveuserNameSharePreference(
  //             querySnapshotInfor.docs[0].data()["name"]);
  //         helperFunctions.saveuserEmailSharePreference(
  //             querySnapshotInfor.docs[0].data()["email"]);
  //
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (context) => ChatRoom()));
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.cyanAccent, Colors.pink])),
          child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0x1F8E1313)),
                    child: Image.asset('assets/images/img_logo.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      "Hello😊\nWelcome Back",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
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
                                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Text(_showpass ? "HIDE" : "SHOW",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        // signIn();
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                    ),
                  )),
                  Center(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          'Sign In with Google',
                          style: TextStyle(
                            fontSize: 15,
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
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "NEW USER",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "FORGOT PASSWORD",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              )),
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
