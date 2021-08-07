import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_call_app/constants.dart';
import 'package:video_call_app/models/app_user_model.dart';
import 'package:video_call_app/resources/firebase_repository.dart';
import 'package:video_call_app/widgets/custom_title.dart';

import 'chatscreens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseRepository _repository = FirebaseRepository();
  List<AppUser> userList = [];
  String query = '';
  TextEditingController _textController = TextEditingController();
  User? currentUser;

  @override
  void initState() {
    currentUser = _repository.getCurrentUser();
    _repository.fetchAllUsers(currentUser).then((List<AppUser> list) {
      setState(() {
        userList = list;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildSearchBar(context),
      body: buildSuggestions(query),
    );
  }

  buildSuggestions(query) {
    final List<AppUser> suggestionList = userList.where((AppUser user) {
      String _getUsername = user.username.toLowerCase();
      String _query = query.toLowerCase();
      String _getName = user.name.toLowerCase();
      bool matchesUsername = _getUsername.contains(_query);
      bool matchesName = _getName.contains(_query);

      return (matchesUsername || matchesName);

      // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
      //     (user.name.toLowerCase().contains(query.toLowerCase()))),
    }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        AppUser searchedUser = AppUser(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username,
            email: suggestionList[index].email,
            status: suggestionList[index].status,
            state: suggestionList[index].state);

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          receiver: userList[index],
                        )));
          },
          leading: Hero(
            tag: searchedUser.uid,
            child: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(searchedUser.profilePhoto),
              backgroundColor: Colors.grey,
            ),
          ),
          title: Text(
            searchedUser.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.email,
            style: TextStyle(color: kGreyColor),
          ),
          onLongPress: () {},
        );
      }),
    );
  }

  AppBar buildSearchBar(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: _textController,
        onChanged: (val) {
          setState(() {
            query = val;
          });
        },
        cursorColor: kBackgroundColor,
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              WidgetsBinding.instance!
                  .addPostFrameCallback((_) => _textController.clear());
            },
          ),
          border: InputBorder.none,
          hintText: "Type username or name",
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
      elevation: 0,
      backgroundColor: kGradientColorEnd,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
