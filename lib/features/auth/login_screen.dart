import 'package:e_commerce_app/features/auth/register_screen.dart';
import 'package:e_commerce_app/network/firbase_manager.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isHiddenPass = true;
 bool remember= false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                  controller: _emailController,
                  hintText: 'enter your email',
                  prefixIcon: Icons.email,
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
                  controller: _passwordController,
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
                    onChanged: (value){
                      setState(() {
                        remember = value!;
                      });
                    },
                  checkboxShape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,

                    )
                  ),
                   side: BorderSide(
                     color: Colors.white,
                     width: 2
                   ),
                  fillColor: WidgetStateProperty.resolveWith(
                      (Set<WidgetState> states){
                        if(states.contains(WidgetState.selected)) return Colors.white;
                        return Colors.transparent;
                      }
                  ),
                  checkColor: Color(0xff004182),
                  title:Text('Remember me' , style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),),
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: ElevatedButton(
                    onPressed: login,
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
                          Navigator.pushNamed(
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

  login() {
    if (_formKey.currentState!.validate()) {
      FirebaseManager.signin(_emailController.text, _passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>LayoutScreen())
      );
    }
  }
}
