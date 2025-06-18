import 'package:e_commerce_app/dialog_utils.dart';
import 'package:e_commerce_app/features/auth/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_text_form_field.dart';
import '../layout/layout_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isHiddenPass = true;
  bool remember = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff004182),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'please, sign in with your email',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Email Address',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                CustomTextFormField(
                  controller: emailController,
                  hintText: 'enter your email',
                  prefixIcon: Icons.email,
                  type: TextInputType.emailAddress,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your email';
                    } else if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+',
                    ).hasMatch(value)) {
                      return 'enter a valid email';
                    }
                    return null;
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Password',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: 'enter your password',
                  prefixIcon: Icons.lock,
                  secure: isHiddenPass,
                  suffixIcon: IconButton(
                    onPressed: () {
                      isHiddenPass = !isHiddenPass;
                      setState(() {});
                    },
                    icon: Icon(
                      isHiddenPass ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 chars';
                    }
                    return null;
                  },
                ),
                CheckboxListTile(
                  value: remember,
                  onChanged: (value) {
                    setState(() {
                      remember = value!;
                    });
                  },
                  checkboxShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                  ),
                  side: BorderSide(color: Colors.white, width: 2),
                  fillColor: WidgetStateProperty.resolveWith((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.selected))
                      return Colors.white;
                    return Colors.transparent;
                  }),
                  checkColor: Color(0xff004182),
                  title: Text(
                    'Remember me',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff004182),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RegisterScreen.routeName,
                          );
                        },
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {

    try {
      DialogUtils.showLoading(context: context, message: 'Loading...');
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', credential.user!.uid);
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(
        context: context,
        content: 'Login Successfully',
        title: 'Login',
        posName: 'ok',
        posAction:
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LayoutScreen()),
            ),
      );

    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-credential') {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
          context: context,
          content: 'The supplied auth credential is incorrect, malformed or has expired. or No user found for that email.',
          title: 'Error',
        );
        print('No user found for that email.');
      }else if(e.code =='invalid-email'){
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
          context: context,
          content: ' The email address is badly formatted.',
          title: 'Error',
        );
      }
      return null;
    } catch (e) {
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(
        context: context,
        content: e.toString(),
        title: 'Error',
      );
      print(e);
      return null;
    }
  }
}
