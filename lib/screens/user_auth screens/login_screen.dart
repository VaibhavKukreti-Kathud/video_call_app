import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_call_app/constants.dart';
import 'package:video_call_app/resources/firebase_repository.dart';
import 'package:video_call_app/screens/user_auth%20screens/widgets/background_painter.dart';
import 'package:video_call_app/widgets/rounded_button.dart';

import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final Repository _repository = Repository();
  bool isButtonPressed = false;
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  late AnimationController _controller;

  String? pwd;
  String? mail;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

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
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _controller,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: mailController,
                onChanged: (v) {
                  setState(() {
                    mail = v;
                  });
                },
              ),
              TextField(
                controller: passController,
                onChanged: (v) {
                  setState(() {
                    pwd = v;
                  });
                },
              ),
              HeightBox(20),
              RoundedMaterialButton(
                  onPressed: () {
                    setState(() {
                      isButtonPressed = true;
                    });
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: mail!, password: pwd!)
                        .then((value) => print(value.toString()));
                  },
                  title: 'Login',
                  icon: Icon(Icons.vpn_key)),
              HeightBox(10),
              RoundedMaterialButton(
                title: 'Google',
                icon: Icon(FontAwesomeIcons.google,
                    size: 20, color: Colors.white),
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
            ],
          ).pSymmetric(h: 20),
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
