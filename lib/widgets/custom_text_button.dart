import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressedAction;

  CustomTextButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.onPressedAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressedAction,
      child: Column(
        children: [
          Icon(
            icon,
            size: 100,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
      style: TextButton.styleFrom(
        alignment: Alignment.center,
      ),
    );
  }
}
