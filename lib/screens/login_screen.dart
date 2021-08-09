import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_call_app/constants.dart';
import 'package:video_call_app/resources/firebase_repository.dart';
import 'package:video_call_app/screens/homescreen.dart';
import 'package:video_call_app/widgets/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseRepository _repository = FirebaseRepository();
  bool isButtonPressed = false;

  void authenticateUser(User? user, _) {
    _repository.authenticateUser(user).then((bool? isNewUser) {
      if (isNewUser == true) {
        _repository.addDataToDB(user).then((value) => Navigator.pushReplacement(
            _, MaterialPageRoute(builder: (_) => HomeScreen())));
      } else {
        Navigator.pushReplacement(
            _, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });
    setState(() {
      isButtonPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: RoundedMaterialButton(
              title: 'Google',
              icon:
                  Icon(FontAwesomeIcons.google, size: 20, color: Colors.white),
              onPressed: () {
                print("trying to perform login");
                setState(() {
                  isButtonPressed = true;
                });

                _repository.signIn().then((User? user) {
                  print("wait");
                  if (user != null) {
                    authenticateUser(user, context);
                  } else {
                    print("There was an error");
                  }
                });
              },
            ),
          ),
          isButtonPressed
              ? Container(
                  color: Colors.black.withOpacity(0.2),
                )
              : Container(),
          isButtonPressed ? CircularProgressIndicator() : Container(),
        ],
      ),
    );
  }
}
