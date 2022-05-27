import 'dart:developer';

import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final TextInputType inputType;
  final bool autoFocus;

  const TextFieldInput({
    Key? key,
    required this.controller,
    this.isPassword = false,
    this.hintText = "",
    this.inputType = TextInputType.text,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
      // onChanged: (value) => log(controller.text), // Use only for dev purposes
      controller: controller,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8.0),
      ),
      keyboardType: inputType,
      obscureText: isPassword,
    );
  }
}
