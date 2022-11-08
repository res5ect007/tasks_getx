import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontFamily;

  GradientText({required this.text, required this.fontSize, required this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [Colors.lightBlue, Colors.indigoAccent],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))));
  }
}
