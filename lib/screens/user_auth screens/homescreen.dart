import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_call_app/constants.dart';
import 'package:video_call_app/enum/user_state.dart';
import 'package:video_call_app/provider/user_provider.dart';
import 'package:video_call_app/resources/auth_fucnctions.dart';
import 'package:video_call_app/resources/firebase_repository.dart';
import 'package:video_call_app/screens/callscreens/pickup/pickup_layout.dart';
import 'package:video_call_app/screens/slide_pages/chat_list_screen.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Repository _repository = Repository();
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  User? currentUser;

  void signOutNRedirect(context) {
    _repository.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  void initState() {
    currentUser = _repository.getCurrentUser();
    super.initState();
  }

  List<Widget> _buildPages(BuildContext context) {
    return [
      ChatListScreen(
        user: currentUser!,
      ),
      GestureDetector(
        onTap: () {
          signOutNRedirect(context);
        },
        child: Center(
            child: Text(
          'Call logs',
          style: TextStyle(color: Colors.white),
        )),
      ),
      GestureDetector(
        onTap: () {
          signOutNRedirect(context);
        },
        child: Center(
            child: Text(
          'Contacts',
          style: TextStyle(color: Colors.white),
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: kBackgroundColor,
        body: PageView(
          controller: pageController,
          onPageChanged: (i) {
            setState(() {
              currentPage = i;
            });
          },
          children: _buildPages(context),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              activeColor: kLightBlueColor,
              iconSize: 25,
              backgroundColor: kBackgroundColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
                BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded), label: 'Contacts'),
              ],
              onTap: (page) {
                pageController.animateToPage(page,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic);
              },
              currentIndex: currentPage,
            ),
          ),
        ),
      ),
    );
  }
}
