import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientLine extends StatelessWidget {
  const GradientLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.width * 0.05,
      child: Center(
        child: Container(
          height: 1,
          margin: EdgeInsetsDirectional.only(
              start: Get.width * 0.1, end: Get.width * 0.1),
          decoration: BoxDecoration(
            gradient: Gradient.lerp(
                const LinearGradient(colors: [Colors.indigo, Colors.blue]),
                const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
