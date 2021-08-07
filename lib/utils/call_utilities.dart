import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_call_app/models/app_user_model.dart';
import 'package:video_call_app/models/call.dart';
import 'package:video_call_app/resources/call_functions.dart';
import 'package:video_call_app/screens/callscreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({required AppUser from, required AppUser to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
      hasDialled: false,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
