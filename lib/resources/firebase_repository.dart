import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_call_app/models/app_user_model.dart';
import 'package:video_call_app/models/message_model.dart';
import 'package:video_call_app/provider/image_upload_provider.dart';
import 'package:video_call_app/resources/firebase_functions.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  User? getCurrentUser() => _firebaseMethods.currentUser;

  Future<AppUser> getUserDetails() => _firebaseMethods.getUserDetails();

  Future<User?> signIn() => _firebaseMethods.signIn();

  Future<bool?> authenticateUser(User? user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDB(User? user) => _firebaseMethods.addDataToDB(user);

  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<AppUser>> fetchAllUsers(currentUser) =>
      _firebaseMethods.fetchAllUsers(currentUser);

  Future<DocumentReference> addMessageToDB(
          Message message, AppUser sender, AppUser receiver) =>
      _firebaseMethods.addMessageToDB(message, sender, receiver);

  Future<String?> uploadImageToStorage(File imageFile) =>
      _firebaseMethods.uploadImageToStorage(imageFile);

  // void showLoading(String receiverId, String senderId) =>
  //     _firebaseMethods.showLoading(receiverId, senderId);

  // void hideLoading(String receiverId, String senderId) =>
  //     _firebaseMethods.hideLoading(receiverId, senderId);

  void uploadImageMsgToDb(String url, String receiverId, String senderId) =>
      _firebaseMethods.setImageMsg(url, receiverId, senderId);

  void uploadImage(
          {required File image,
          required String receiverId,
          required String senderId,
          required ImageUploadProvider imageUploadProvider}) =>
      _firebaseMethods.uploadImage(
          image, receiverId, senderId, imageUploadProvider);
}
