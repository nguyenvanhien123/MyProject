import 'package:flutter/material.dart';
import 'package:myapp/helper/authenicate.dart';
import 'package:myapp/services/auth.dart';

class user_information extends StatefulWidget {
  @override
  _user_informationState createState() => _user_informationState();
}

class _user_informationState extends State<user_information> {
  AuthMethods authMethods = new AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Tôi"),
      ),
      body: Container(
        child: Center(
          // ignore: deprecated_member_use
          child: FlatButton(
            onPressed: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenicate()));
            },
            child: Text(
              "SignOut",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
