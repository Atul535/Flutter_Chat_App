import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final bool? isObscure;
  final bool? isEnabled;
  final TextEditingController controller;
  const AuthField({
    super.key,
    required this.hintText,
    this.isObscure = false,
    this.isEnabled = true,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      obscureText: isObscure!,
      enabled: isEnabled!,
      controller: controller,
    );
  }
}
