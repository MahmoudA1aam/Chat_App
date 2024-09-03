import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      this.validator,
      this.label,
      required this.controller,
      this.hintText,
      this.suffixIcon,
        this.textInputAction,
      this.obscureText = false,
      this.maxLines = 1});

  final TextEditingController controller;
  final FormFieldValidator? validator;
  int maxLines;
  Widget? suffixIcon;
  String? hintText, label;
  bool obscureText;
  TextInputAction?textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIconColor: Colors.black,
        focusColor: Colors.black,
        floatingLabelStyle: const TextStyle(color: Colors.black),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        suffixIcon: suffixIcon,
        labelText: label,
        hintText: hintText,
      ),
    );
  }
}
