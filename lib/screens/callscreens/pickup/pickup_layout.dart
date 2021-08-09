import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call_app/models/call.dart';
import 'package:video_call_app/provider/user_provider.dart';
import 'package:video_call_app/resources/call_functions.dart';
import 'pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser!.uid),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data.exists) {
                Call call = Call.fromMap(snapshot.data.data());
                if (!call.hasDialled!) {
                  return PickupScreen(call: call);
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
