import 'package:e_commerce_app/features/auth/login_screen.dart';
import 'package:e_commerce_app/features/layout/layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? routeName;
  @override
  void initState() {

    checkCurrentUser();
    Future.delayed(
      Duration(seconds: 3),
      () => {
        if (mounted && routeName != null){
      Navigator.pushNamedAndRemoveUntil(
      context,
      routeName!,
      (Route<dynamic> route) => false,
      )}}
    );
    super.initState();
  }

  checkCurrentUser() {
    FirebaseAuth.instance.signOut();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        routeName = LoginScreen.routeName;
      } else {
        routeName = LayoutScreen.routeName;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash-screen.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
