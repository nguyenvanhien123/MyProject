import 'package:flutter/material.dart';
import 'package:myapp/views/signin.dart';
import 'package:myapp/views/signup.dart';
class Authenicate extends StatefulWidget {
  @override
  _AuthenicateState createState() => _AuthenicateState();
}

class _AuthenicateState extends State<Authenicate> {
    bool showSignIn = true;
    void toggleView(){
   setState(() {
     showSignIn =! showSignIn;
   });
    }
  @override
  Widget build(BuildContext context) {
     if (showSignIn){
      return SignIn(toggleView);
    } else{
       return SignUp(toggleView);

    }
  }
}
