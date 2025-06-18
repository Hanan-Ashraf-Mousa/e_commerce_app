
import 'package:e_commerce_app/features/products/products_category_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/layout/layout_screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        LayoutScreen.routeName: (context) => LayoutScreen(),
        ProductsCategoryScreen.routeName:(context)=>ProductsCategoryScreen(),
      },
    );
  }
}
