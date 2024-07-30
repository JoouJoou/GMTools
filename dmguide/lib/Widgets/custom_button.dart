import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3CA8CF),  // Usar backgroundColor em vez de primary
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24.0,
            color: Color(0xFFFFF9EA),
          ),
        ),
      ),
    );
  }
}
