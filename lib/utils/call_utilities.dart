import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/Model/UserInfor.dart';
import 'package:myapp/Model/call.dart';
import 'package:myapp/Model/log.dart';
import 'package:myapp/helper/strings.dart';
import 'package:myapp/local_database/repository/log_repository.dart';
import 'package:myapp/services/call_methods.dart';
import 'package:myapp/views/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserInfor from, UserInfor to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      LogRepository.addLogs(log);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
    if (call.hasDialled = false) {
      Navigator.pop(context);
    }
  }
}
