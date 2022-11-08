import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/task_controller.dart';

class NoConnectionPage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[400],
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: Get.height * 0.15,
            left: Get.width * 0.1,
            child: Text('oops'.tr.toUpperCase(), style: const TextStyle(fontSize: 75,fontFamily: 'Staatliches'))
      ),
        Positioned(
            top: Get.height * 0.75,
            left: Get.width * 0.1,
            child: Text('no_internet'.tr.toUpperCase(), style: const TextStyle(fontSize: 20,fontFamily: 'Staatliches'))
        ),

          Image.asset(
            "assets/images/no_connection.png",
            fit: BoxFit.contain,
          ),
          Positioned(
            bottom: Get.height * 0.08,
            left: Get.width * 0.1,
            child: FlatButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {
                taskController.fetchTasks();
                Get.toNamed('/home');},
              child: Text('retry'.tr.toUpperCase()),
            ),
          )
        ],
      ),
    );
  }
}