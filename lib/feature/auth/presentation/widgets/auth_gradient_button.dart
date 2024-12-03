import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton(
      {super.key, required this.buttonText, required this.onPressed});
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: LinearGradient(colors: [
          AppPallete.gradient1,
          AppPallete.gradient2,
        ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.transparentColor,
          fixedSize: const Size(395, 55),
          shadowColor: AppPallete.transparentColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
