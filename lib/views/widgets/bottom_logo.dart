import 'package:flutter/material.dart';
import 'gradient_text.dart';

class Bottom extends StatelessWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GradientText(
        fontFamily: 'Staatliches',
        fontSize: 18.0,
        text: 'Business Automation Software',
      ),
    );
  }
}