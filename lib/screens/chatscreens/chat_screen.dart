import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_call_app/const_strings.dart';
import 'package:video_call_app/constants.dart';
import 'package:video_call_app/enum/view_state.dart';
import 'package:video_call_app/models/app_user_model.dart';
import 'package:video_call_app/models/message_model.dart';
import 'package:video_call_app/provider/image_upload_provider.dart';
import 'package:video_call_app/resources/firebase_repository.dart';
import 'package:video_call_app/screens/chatscreens/widgets/cached_image.dart';
import 'package:video_call_app/utils/call_utilities.dart';
import 'package:video_call_app/utils/utilities.dart';
import 'package:video_call_app/widgets/custom_appbar.dart';
import 'package:video_call_app/widgets/custom_title.dart';

class ChatScreen extends StatefulWidget {
  final AppUser receiver;

  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textFieldController = TextEditingController();
  final FirebaseRepository _repository = FirebaseRepository();
  AppUser? sender;
  late String _currentUserID;
  bool isWriting = false;
  bool showEmojiPicker = false;
  FocusNode textFieldFocus = FocusNode();
  final ScrollController chatListController = ScrollController();
  XFile? imageFile;
  ImageUploadProvider? _imageUploadProvider;

  @override
  void initState() {
    User currentUser = _repository.getCurrentUser()!;
    _currentUserID = currentUser.uid;
    setState(() {
      sender = AppUser(
        uid: currentUser.uid,
        name: currentUser.displayName!,
        profilePhoto: currentUser.photoURL!,
        state: '',
        username: Utils.getUsername(currentUser.email!),
        email: currentUser.email!,
        status: 'Online',
      );
    });
    super.initState();
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _imageUploadProvider!.getViewState == ViewState.LOADING
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: CircularProgressIndicator(),
                )
              : Container(),
          chatControls(),
          showEmojiPicker
              ? SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        isWriting = true;
                      });
                      textFieldController.text =
                          textFieldController.text + emoji.emoji;
                    },
                    config: Config(
                      bgColor: kBackgroundColor,
                      buttonMode: ButtonMode.CUPERTINO,
                      indicatorColor: kSeparatorColor,
                      columns: 7,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(MESSAGES_COLLECTION)
          .doc(_currentUserID)
          .collection(widget.receiver.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something\'s gone wrong. Please try again later');
        }

        if (snapshot.data == null) {
          return Container(child: Center(child: CircularProgressIndicator()));
        }

        // SchedulerBinding.instance!.addPostFrameCallback((_) {
        //   chatListController.animateTo(
        //       chatListController.position.minScrollExtent,
        //       duration: Duration(milliseconds: 250),
        //       curve: Curves.bounceOut);
        // });

        return ListView.builder(
          padding: EdgeInsets.all(10),
          controller: chatListController,
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(snapshot) {
    Message _message = Message.fromMap(snapshot.data()!);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        alignment: _message.senderId == _currentUserID
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserID
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(15);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(top: 0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: kSenderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: getMessage(message),
    );
  }

  Widget getMessage(Message message) {
    if (message.type != 'image') {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          message.message!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(5),
        child: CachedImage(
          message.photoUrl!,
          radius: 10,
        ),
      );
    }
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(15);

    return Container(
      margin: EdgeInsets.only(top: 0),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: kReceiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          topLeft: messageRadius,
        ),
      ),
      child: getMessage(message),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: kBackgroundColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      MaterialButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                        },
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                      ),
                      ModalTile(
                          onPressed: () {},
                          title: "File",
                          subtitle: "Share files",
                          icon: Icons.tab),
                      ModalTile(
                          onPressed: () {},
                          title: "Contact",
                          subtitle: "Share contacts",
                          icon: Icons.contacts),
                      ModalTile(
                          onPressed: () {},
                          title: "Location",
                          subtitle: "Share a location",
                          icon: Icons.add_location),
                      ModalTile(
                          onPressed: () {},
                          title: "Schedule Call",
                          subtitle: "Arrange a skype call and get reminders",
                          icon: Icons.schedule),
                      ModalTile(
                          onPressed: () {},
                          title: "Create Poll",
                          subtitle: "Share polls",
                          icon: Icons.poll)
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: kFabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: kSeparatorColor,
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      focusNode: textFieldFocus,
                      onTap: () {
                        hideEmojiContainer();
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (val) {
                        (val.length > 0 && val.trim() != "")
                            ? setWritingTo(true)
                            : setWritingTo(false);
                      },
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle: TextStyle(
                          color: kGreyColor.withOpacity(0.4),
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () => pickImage(ImageSource.camera),
                      child: Icon(Icons.camera_alt_rounded)),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (!showEmojiPicker) {
                          hideKeyboard();
                          showEmojiContainer();
                        } else {
                          hideEmojiContainer();
                          showKeyboard();
                        }
                      },
                      child: Icon(Icons.emoji_emotions)),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: kFabGradient, shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 18,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  sendMessage() {
    String text = textFieldController.text;
    Message message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender!.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );
    setState(() {
      isWriting = false;
    });
    _repository.addMessageToDB(message, sender!, widget.receiver);
    textFieldController.clear();
  }

  pickImage(ImageSource source) async {
    File selectedImage = await Utils.pickImage(source);
    _repository.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserID,
        imageUploadProvider: _imageUploadProvider!);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Row(
        children: [
          Hero(
            tag: widget.receiver.uid,
            child: CircleAvatar(
                radius: 16,
                backgroundImage:
                    CachedNetworkImageProvider(widget.receiver.profilePhoto)),
          ),
          SizedBox(width: 9),
          Text(
            widget.receiver.name,
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
            padding: EdgeInsets.all(10),
            icon: Icon(
              FontAwesomeIcons.video,
              size: 18,
            ),
            onPressed: () => CallUtils.dial(
                from: sender!, to: widget.receiver, context: context)),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function() onPressed;

  const ModalTile({
    required this.onPressed,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: kReceiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: kGreyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: kGreyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        onLongPress: () {},
        onTap: onPressed,
      ),
    );
  }
}
