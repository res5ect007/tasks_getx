import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/extensions.dart';
import '../lib/controllers/period_controller.dart';
import '../lib/controllers/task_controller.dart';
import '../lib/views/widgets/task_tile.dart';

class TaskPage1 extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final PeriodController periodController = Get.put(PeriodController());
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  TaskPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Obx(() {
        final tasksMap = { for (var item in taskController.taskList) item.partner : item };
        var tasks = tasksMap[taskController.selectedPartner]?.tasks;
        return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Row(
              children: [
                IconButton(onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back)),
                Expanded(
                  child: Text(
                      taskController.selectedPartner.value
                      , style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 23),
                      textAlign: TextAlign.center),
                ),
                SizedBox(width: Get.width * 0.1)
              ],
            ),
          ),
          //const GradientLine(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 2,bottom: 5),
            child: Row(
              children: [
                const Spacer(),
                const Icon(Icons.access_time, size: 20),
                Text( tasksMap[taskController.selectedPartner] == null ?
                ' 0 ${'hh'.tr} 0 ${'mm'.tr}' : ' ${tasksMap[taskController.selectedPartner]?.allTime.getTimeFormated()}',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          DateTime maxDateTime = periodController.periodData[periodController.periodData.length - 1];
                          maxDateTime = DateTime(maxDateTime.year, 12, 31);

                          DateTime minDateTime =  periodController.periodData[0];
                          minDateTime = DateTime(minDateTime.year, 01, 01);

                          return SizedBox(
                            height: 255,
                            child: DateTimePickerWidget(
                              minDateTime: minDateTime,
                              maxDateTime: maxDateTime,
                              initDateTime: periodController.periodData[periodController.selectedPeriodIndex],
                              locale: DateTimePickerLocale.ru,
                              dateFormat: 'MMMM, yyyy',
                              pickerTheme: DateTimePickerTheme(
                                backgroundColor: Colors.transparent,
                                itemTextStyle: TextStyle(color: ThemeData().primaryColor),
                                confirmTextStyle: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
                                    fontSize: 17),
                                cancelTextStyle: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
                                    fontSize: 17),
                              ),
                              onConfirm:  (dateTime, number) async {
                                int index = periodController.periodData.keys.firstWhere((key) => periodController.periodData[key] == dateTime,
                                    orElse: () => periodController.selectedPeriodIndex);
                                if (periodController.selectedPeriodIndex.value != index) {

                                  periodController.selectedPeriodIndex.value = index;
                                  refreshIndicatorKey.currentState?.show();
                                  await Future.delayed(const Duration(seconds:  4));
                                  taskController.fetchTasks();
                                }
                              },
                              onChange: (dateTime, number) {
                                HapticFeedback.vibrate();
                              },
                            ),
                          );
                        });
                  },
                  child: Text(
                      '${periodController.convertPeriodToText(periodController.periodData[periodController.selectedPeriodIndex], false)}',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
              ],
            ),
          ),
          if (tasks != null) ...[
          Expanded(
              child: RefreshIndicator(
                key: refreshIndicatorKey,
                onRefresh: () async {
                  taskController.fetchTasks();
                  refreshIndicatorKey.currentState?.show();
                  },
                strokeWidth: 3.0,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  itemCount:tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    var heightIndex = tasks[index].discription.numberOfStringInTile();
                    return GestureDetector(
                        onTap: () => Get.toNamed('/task_edit'),
                        child: TaskTile(tasks[index], 0.105 + (0.025 * heightIndex) , 1));
                  },
                ),
              ),
            ),
            ] else ...[
              const Expanded(
                  flex: 4,
                  child: Image(
                      image: AssetImage('assets/images/no_tasks.png'))),
              Expanded(
                  flex: 2,
                  child: Text('${'oops'.tr} ${'no_tasks'.tr}',
                      style: const TextStyle(fontSize: 30))),
            ],
          ],
      );
    }),
      floatingActionButton: GestureDetector(
        onTap: () => Get.toNamed('/task_edit'),
        child: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 30,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      //bottomSheet:
    );
  }
}

Future refresh() async {
    final TaskController taskController = Get.put(TaskController());
    taskController.fetchTasks();
}