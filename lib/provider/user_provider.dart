import 'package:flutter/widgets.dart';
import 'package:video_call_app/models/app_user_model.dart';
import 'package:video_call_app/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  AppUser? _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  AppUser? get getUser => _user;

  void refreshUser() async {
    AppUser? user = await _firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
