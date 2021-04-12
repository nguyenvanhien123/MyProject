import 'package:flutter/material.dart';
import 'package:myapp/utils/universal_variables.dart';

import '../../searchScreen.dart';

class FloatingColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => searchScreen()));
          },
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: UniversalVariables.blackColor,
                border: Border.all(
                  width: 2,
                  color: UniversalVariables.gradientColorEnd,
                )),
            child: Icon(
              Icons.add_call,
              color: UniversalVariables.gradientColorEnd,
              size: 25,
            ),
            padding: EdgeInsets.all(15),
          ),
        )
      ],
    );
  }
}
