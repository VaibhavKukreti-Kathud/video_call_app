import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_call_app/const_strings.dart';
import 'package:video_call_app/models/app_user_model.dart';
import 'package:video_call_app/models/message_model.dart';
import 'package:video_call_app/provider/image_upload_provider.dart';
import 'package:video_call_app/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late Reference _reference;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //AppUser class
  late AppUser user;

  //Get current user if signed in already
  User? get currentUser => _auth.currentUser;

  //sign in with google
  Future<User?> signIn() async {
    GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken!,
        idToken: _signInAuthentication.idToken!);

    User? user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  //checks if the user is new or not
  Future<bool?> authenticateUser(User? user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user!.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;

    //if user is already registered, the length of list > 0 otherwise 0
    return docs.length == 0 ? true : false;
  }

  //adds the user to firestore if new
  Future<void> addDataToDB(User? currentUser) async {
    AppUser user = AppUser(
      uid: currentUser!.uid,
      name: currentUser.displayName!,
      email: currentUser.email!,
      username: Utils.getUsername(currentUser.email!),
      status: 'Online',
      state: '10',
      profilePhoto: currentUser.photoURL!,
    );

    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  //pata chal he gya hoga naam se
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  //fetch a list of all the users and return it without the current user
  Future<List<AppUser>> fetchAllUsers(User currentUser) async {
    List<AppUser> userList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(AppUser.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  User? getCurrentUser() {
    User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<AppUser> getUserDetails() async {
    User currentUser = getCurrentUser()!;

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.doc(currentUser.uid).get();

    return AppUser.fromMap(documentSnapshot.data.call()!);
  }

  //TODO: fix this method
  updateStatus(bool isWriting, String data) async {
    if (isWriting) {
      await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(currentUser!.uid)
          .update({'status': data});
    } else {
      await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(currentUser!.uid)
          .update({'status': data});
    }
  }

  Future<DocumentReference> addMessageToDB(
      Message message, AppUser sender, AppUser receiver) async {
    var map = message.toMap();
    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.senderId)
        .collection(message.receiverId!)
        .add(map);
    return await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.receiverId)
        .collection(message.senderId!)
        .add(map);
  }

  Future<String?> uploadImageToStorage(File image) async {
    try {
      _reference = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().microsecondsSinceEpoch.toString());
      UploadTask _uploadTask = _reference.putFile(image);
      Future<String> url =
          await _uploadTask.then((a) => a.ref.getDownloadURL());
      return url;
    } catch (e) {
      print(e);
    }
  }

  void setImageMsg(String url, String receiverID, String senderID) async {
    Message _message;
    _message = Message.imageMessage(
        senderId: senderID,
        receiverId: receiverID,
        message: '',
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: MESSAGE_TYPE_IMAGE);
    Map<String, dynamic> map = _message.toImageMap();
    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(_message.senderId)
        .collection(_message.receiverId!)
        .add(map);
    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(_message.receiverId)
        .collection(_message.senderId!)
        .add(map);
  }

  void uploadImage(File image, String receiverID, String senderID,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String? url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    setImageMsg(url!, receiverID, senderID);
  }
}
