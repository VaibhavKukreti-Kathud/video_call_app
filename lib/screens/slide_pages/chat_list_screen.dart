import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/constants.dart';
import 'package:video_call_app/resources/firebase_repository.dart';
import 'package:video_call_app/utils/utilities.dart';
import 'package:video_call_app/widgets/custom_appbar.dart';
import 'package:video_call_app/widgets/custom_title.dart';

final FirebaseRepository _repository = FirebaseRepository();

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late User currentUser;
  late String currentUserID;
  late String initials;
  @override
  void initState() {
    currentUser = _repository.getCurrentUser()!;
    setState(() {
      currentUserID = currentUser.uid;
      initials = Utils.getInitials(currentUser.displayName!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_rounded,
            color: Colors.white,
          ),
        ),
        title: UserCircle(initials),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search_screen');
              },
              icon: Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ChatListContainer(currentUserID),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kLightBlueColor,
        child: Icon(
          Icons.edit_rounded,
          color: kIconColor,
          size: 25,
        ),
      ),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;

  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 8.0 : 0),
            child: CustomTile(
                onLongPress: () {},
                mini: false,
                onTap: () {},
                title: Text(
                  "Basudev Kukreti",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Arial", fontSize: 19),
                ),
                subtitle: Text(
                  "Hello",
                  style: TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                leading: Container(
                  constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            "https://lh3.googleusercontent.com/a-/AOh14GhWS7FuCGHxjZNwn-B9ebq-z58EFij5a1QdOfVB=s90-c"),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kOnlineDotColor,
                              border: Border.all(
                                  color: kBackgroundColor, width: 2)),
                        ),
                      )
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}

class UserCircle extends StatelessWidget {
  final String text;

  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kSeparatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kLightBlueColor,
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kBackgroundColor, width: 2),
                    color: kOnlineDotColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: kFabGradient, borderRadius: BorderRadius.circular(50)),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
