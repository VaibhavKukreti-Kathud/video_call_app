import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call_app/constants.dart';
import 'package:video_call_app/provider/image_upload_provider.dart';
import 'package:video_call_app/resources/firebase_repository.dart';
import 'package:video_call_app/screens/homescreen.dart';
import 'package:video_call_app/screens/login_screen.dart';
import 'package:video_call_app/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageUploadProvider>(
      create: (context) => ImageUploadProvider(),
      child: MaterialApp(
        color: kBackgroundColor,
        theme: ThemeData(
            backgroundColor: kBackgroundColor,
            colorScheme: ColorScheme.dark(
                background: kBackgroundColor, primary: kBlueColor),
            buttonColor: kLightBlueColor,
            iconTheme: IconThemeData(color: Colors.white),
            primaryColor: kBlueColor),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        home:
            _repository.getCurrentUser() != null ? HomeScreen() : LoginScreen(),
      ),
    );
  }
}
