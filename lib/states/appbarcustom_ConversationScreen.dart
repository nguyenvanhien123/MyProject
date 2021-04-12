import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/views/user_information.dart';

class appbarcustom_ConversationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Centers horizontally
      crossAxisAlignment: CrossAxisAlignment.center, // Centers vertically
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => user_information()));
          },
        ),

        // The SizedBox provides an immediate spacing between the widgets
        SizedBox(
          width: 3,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
          child: Text(
            "Chat",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        )
      ],
    );
  }
}
