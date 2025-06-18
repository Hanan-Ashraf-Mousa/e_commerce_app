import 'dart:io';

import 'package:e_commerce_app/network/firbase_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   UserModel? user ;
   bool isLoading = true;
   String? errorMessage;
  @override
  void initState() {
    super.initState();
    getUser();
  }
   Future<void> getUser() async {
     setState(() {
       isLoading = true;
       errorMessage = null;
     });
     try {
       // user = await FirebaseManager().getUserProfile();
      setState(() {

       });
       if (user == null) {
         errorMessage = 'Failed to load user profile';
       }
     } catch (e) {
       errorMessage = 'Error: $e';
     }
     setState(() {
       isLoading = false;
     });
   }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null || user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage ?? 'No user data found'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: getUser,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
              (user!.path != null) ? FileImage(File(user!.path)) : null,
              child:
              (user!.path == null)
                  ? Icon(
                Icons.person,
                color: Color(0xff004182),
                size: 50,
              )
                  : null,
            ),
            Text(
              user!.name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              ' Email Address: ${user!.email}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),

            Text(
              'Phone: ${user!.phone}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),

            Text(
              'DOB: ${user!.dob}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),

            Text(
              'Address:${user!.address}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),

            Text(
              'Gender: ${user!.gender}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 24.0),

            const SizedBox(height: 16.0),
            // Logout Button
            ElevatedButton(
              onPressed: () async {
                // await FirebaseManager.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Logout',style: TextStyle(
                color: Color(0xff004081),
                fontSize: 20
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
