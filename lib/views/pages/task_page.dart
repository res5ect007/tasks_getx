import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/extensions.dart';
import 'package:tasks_getx/views/widgets/time_select.dart';
import '../../controllers/period_controller.dart';
import '../../controllers/task_controller.dart';
import '../widgets/popup_animation/popup_window.dart';
import '../widgets/task_tile.dart';

class TaskPage extends StatefulWidget {

  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskController taskController = Get.put(TaskController());
  final PeriodController periodController = Get.put(PeriodController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(taskController.selectedPartner.value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 23),
              textAlign: TextAlign.center),
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
         //toolbarHeight: 50,
         backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            //   child: Row(
            //     children: [
            //       IconButton(
            //           onPressed: () => Get.back(),
            //           icon: const Icon(Icons.arrow_back)),
            //       Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 0.1),
            //           child: Text(taskController.selectedPartner.value,
            //               style: const TextStyle(
            //                   fontWeight: FontWeight.w600, fontSize: 23),
            //               textAlign: TextAlign.center),
            //         ),
            //       ),
            //       //  SizedBox(width: Get.width * 0.1)
            //     ],
            //   ),
            // ),
            //const GradientLine(),
            Padding(
              padding:
              const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // const Spacer(),
                  Row(
                    children: [
                      const Icon(
                          Icons.access_time, size: 20, color: Colors.blue),
                      Text(
                          taskController.tasksMap[taskController.selectedPartner
                              .value] == null
                              ? ' 0 ${'hh'.tr} 0 ${'mm'.tr}'
                              : ' ${taskController.tasksMap[taskController
                              .selectedPartner
                              .value]
                              ?.allTime.getTimeFormated()}',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  BottomSheetTimeSelect(task: null),
                ],
              ),
            ),
            if (taskController.partnerTasks.isNotEmpty) ...[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await refresh();
                  },
                  strokeWidth: 3.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                    itemCount: taskController.partnerTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var heightIndex =
                      taskController.partnerTasks[index].discription
                          .numberOfStringInTile();
                      return
                        PopupWindow(
                          heroTag: 'editWidget$index',
                          tapWidget: TaskTile(
                              taskController.partnerTasks[index],
                              0.105 + (0.025 * heightIndex), 1),
                          popupWidget: AddPopupCard(
                              heroTag: 'editWidget$index',
                              task: taskController.partnerTasks[index]),
                        );

                      // GestureDetector(
                      //   onTap: () => Get.toNamed('/task_edit'),
                      //   child: TaskTile(
                      //       tasks[index], 0.105 + (0.025 * heightIndex), 1));
                    },
                  ),
                ),
              ),
            ] else
              ...[
                const Expanded(
                    flex: 4,
                    child:
                    Image(image: AssetImage('assets/images/no_tasks.png'))),
                Expanded(
                    flex: 2,
                    child: Text('${'oops'.tr} ${'no_tasks'.tr}',
                        style: const TextStyle(fontSize: 30))),
              ],
          ],
        ),
        floatingActionButton: PopupWindow(
            heroTag: 'addButton',
            tapWidget: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 30,
                child: Icon(Icons.add, color: Colors.white)),
            popupWidget: AddPopupCard(heroTag: 'addButton', task: null,)),
      );
    });
  }
}

Future<void> refresh() async {
  final TaskController taskController = Get.put(TaskController());
  await taskController.fetchTasks();
  // await Future.delayed(Duration(seconds: 5));
}


