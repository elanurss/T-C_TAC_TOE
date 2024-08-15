import 'package:flutter/material.dart';
import '../constants/constant.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 300,
      height: height ?? 50,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Constants.buttonColor),
            foregroundColor: WidgetStateProperty.all(Constants.textColor)),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1),
        ),
      ),
    );
  }
}
