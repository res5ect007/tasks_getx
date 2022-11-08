import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tasks_getx/controllers/error_controller.dart';
import 'package:tasks_getx/controllers/period_controller.dart';
import '../models/task.dart';
import '../services/base_client.dart';

class TaskController extends GetxController with ErrorController {
  var selectedPartner = ''.obs;
  var isLoading = true.obs;
  var taskList = <Task>[].obs;
  var tasksMap = <String, Task>{}.obs ;
  var partnerTasks = <TaskElement>[].obs;
  // @override
  // void onInit() {
  //   fetchTasks();
  //   super.onInit();
  // }

  Future<void> fetchTasks() async {
    GetStorage box = GetStorage();
    final PeriodController periodController = Get.put(PeriodController());
    // String username = box.read('userName');
    // String password = box.read('password');
    String username = 'Власенко Константин';
    String password = '15935';

    DateTime now = DateTime.now();
    DateTime currentPeriod = periodController.periodData[periodController.selectedPeriodIndex] ?? DateTime(now.year, now.month, 1);
    String currentPeriodFormatted = DateFormat("yyyyMMdd").format(currentPeriod);

    isLoading(true);

    Future.delayed(const Duration(milliseconds: 1500), () async {
    // try {
      //showLoading('Fetching data');
    await BaseClient()
        .get('http://vs.adamax.com.ua:8080', '/1CTasks/hs/task-services/list/$currentPeriodFormatted', username, password)
        .then((value) {
      taskList.value = value ?? [];
      tasksMap.value = {for (var item in value) item.partner: item};

      if (selectedPartner.isNotEmpty && tasksMap[selectedPartner.value] != null) {
        partnerTasks.value = tasksMap[selectedPartner.value]!.tasks;
      } else {
        partnerTasks.value = <TaskElement>[];
      };
      isLoading(false);
    }).catchError(handleError);

    //if(tasks != null) {
       // taskList.value = tasks ?? [];
        //hideLoading();
      //}
    //  } finally {}
    // isLoading(false);
    });
  }


}

