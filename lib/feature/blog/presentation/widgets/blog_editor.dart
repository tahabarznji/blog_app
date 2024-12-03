import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  const BlogEditor(
      {super.key, required this.hintText, required this.controller});
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText value can not be empty';
        }
        return null;
      },
    );
  }
}
