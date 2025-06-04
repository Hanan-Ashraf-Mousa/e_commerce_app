import 'dart:io';

import 'package:e_commerce_app/network/firbase_manager.dart';
import 'package:e_commerce_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../widgets/custom_text_form_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var format = DateFormat('yyyy/mm/dd');
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPassController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dOBController = TextEditingController();
  String _gender = '';
  bool isHiddenPass = true;
  bool isHiddenConfirm = true;
  File? avatar;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dOBController.dispose();
    _addressController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
                SizedBox(height: 40),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            (avatar != null) ? FileImage(avatar!) : null,
                        child:
                            (avatar == null)
                                ? Icon(
                                  Icons.person,
                                  color: Color(0xff004182),
                                  size: 50,
                                )
                                : null,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        radius: 20,
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Color(0xff004182),
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'User Name',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'enter your name',
                  prefixIcon: Icons.person,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your name';
                    }
                    return null;
                  },
                ),
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
                    'Phone Number',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: 'enter your phone',
                  prefixIcon: Icons.phone,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your phone';
                    } else if (!RegExp(r'^01[0125]\d{8}').hasMatch(value)) {
                      return 'enter a valid phone';
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                CustomTextFormField(
                  controller: _confirmPassController,
                  hintText: 'confirm your password',
                  prefixIcon: Icons.lock,
                  secure: isHiddenConfirm,
                  suffixIcon: IconButton(
                    onPressed: () {
                      isHiddenConfirm = !isHiddenConfirm;
                      setState(() {});
                    },
                    icon: Icon(
                      isHiddenConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your confirm password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords doesn\'t match';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Address',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                CustomTextFormField(
                  controller: _addressController,
                  hintText: 'enter your address',
                  prefixIcon: Icons.add_home,
                  lines: 2,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your address';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Date Of Birth',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                CustomTextFormField(
                  controller: _dOBController,
                  hintText: 'enter your dob',
                  prefixIcon: Icons.date_range,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your date of birth';
                    }
                    return null;
                  },
                  onTap: _showDatePicker,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Gender',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'select your gender';
                      }
                      return null;
                    },

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Select your Gender',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorStyle: TextStyle(color: Colors.red, fontSize: 20),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 1.7),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.red, width: 1.7),
                      ),
                    ),
                    items:
                        ['Female', 'Male']
                            .map(
                              (gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      _gender = value!;
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff004182),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      final uid = await FirebaseManager.signup(
        _emailController.text,
        _passwordController.text,
      );
      if(uid !=null){
      UserModel user = UserModel(
        id: uid!,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        gender: _gender,
        address: _addressController.text,
        dob: _dOBController.text,
        path: avatar!.path
      );
      FirebaseManager().storeUser(user);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign up, try again')));
      }
  }}

  _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      avatar = File(image.path);
      setState(() {});
    }
  }

  _showDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      initialDate: DateTime.now().subtract(Duration(days: (365 * 25))),
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: (365 * 25))),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      _dOBController.text = format.format(selectedDate).toString();
    }
    setState(() {});
  }
}
