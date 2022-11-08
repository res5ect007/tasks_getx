import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/extensions.dart';
import '../../models/task.dart';

class TaskTile extends StatelessWidget {
  final TaskElement taskElement;
  final double height;
  final double width;

  TaskTile(this.taskElement, this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width *  width,
      height: Get.height *  height,
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 2),
      child: Card(
        elevation: 5,
        child:Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(taskElement.status.getIconForStatus(), size: 17, color: taskElement.status.getIconColorForStatus()),
                  Text(' ${taskElement.status}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(taskElement.doneDate.getDateFormated(), style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
                ),
                Text(
                  taskElement.discription,
                  //maxLines: 100,
                  style: const TextStyle(fontSize: 15),
                ),
                const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                     const Icon(Icons.access_time, size: 16, color: Colors.blue),
                      Text(' ${taskElement.time.getTimeFormated()}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                    ),
                  )],
              ),
            )
      ),
    );
  }
}