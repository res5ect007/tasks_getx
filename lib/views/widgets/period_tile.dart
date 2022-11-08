import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeriodTile extends StatelessWidget {
  final String? period;
  final double height;
  final double width;
  final bool selectColor;

  PeriodTile(this.period, this.height, this.width, this.selectColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width *  width,
      height: Get.height *  height,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Card(
        elevation: 2.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(11))
         ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.center,
            period!,
            style: TextStyle(color: selectColor ? (MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white) : ThemeData().primaryColor,
            fontWeight: selectColor ? FontWeight.w600 : FontWeight.normal, height: 1.7
            ),
          ),
        ),
      ),
    );
  }

}