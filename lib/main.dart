import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:sports_management_updated/user_login/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HelloApp());
}

class HelloApp extends StatelessWidget {
  const HelloApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: LoginScreen(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/logo2.png",
      backgroundColor: Colors.white,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: example1,
    );
  }
}
