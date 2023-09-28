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
      // validator: (value) {
      //   if (value == null || value.trim().isEmpty || !value.contains('@')) {
      //     return 'Please enter a valid email address!';
      //   }
      //   return null;
      // },
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        // labelText: "Email",
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }
}
