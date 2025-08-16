// ignore: file_names
import 'package:flutter/material.dart';
// ignore: implementation_imports

class CustomTextField extends StatefulWidget {
  final TextEditingController nameController;
  final String hintText;
  const CustomTextField({
    super.key,
    required this.nameController,
    required this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.nameController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
      ),
    );
  }
}
