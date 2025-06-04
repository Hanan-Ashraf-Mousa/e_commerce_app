import 'package:flutter/material.dart';

typedef Validate = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;

  final IconData prefixIcon;

  final String hintText;
  final TextInputType type;

  final Validate? validate;
  final bool secure;

  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final int lines;

  const CustomTextFormField({
    super.key,
    this.lines = 1,
    this.onTap,
    this.secure = false,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.type = TextInputType.text,
    this.validate,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        obscureText: secure,
        obscuringCharacter: '*',
        controller: controller,
        validator: validate,
        maxLines: lines,
        onTap: onTap,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: Icon(prefixIcon, color: Colors.black.withOpacity(0.7)),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
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
          errorStyle: TextStyle(color: Colors.red, fontSize: 20),
        ),
        keyboardType: type,
      ),
    );
  }
}
