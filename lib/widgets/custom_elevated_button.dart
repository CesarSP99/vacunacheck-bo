import 'package:flutter/material.dart';
import '../utils/const.dart';

class CustomElevatedButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressedAction;

  CustomElevatedButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.onPressedAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedAction,
      child: Column(
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.white,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
      style: TextButton.styleFrom(
        backgroundColor: Constants.lightGreen,
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
      ),
    );
  }
}
