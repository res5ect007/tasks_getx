import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/extensions.dart';
import '../../models/task.dart';
import 'package:shimmer/shimmer.dart';

class PartnerTile extends StatelessWidget {
  final Task task;
  final double height;
  final double width;

  const PartnerTile(this.task, this.height, this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
       height: Get.height *  height,
       width: Get.width *  width,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 1, 0, 2),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 99,
                    child: Text(
                      task.partner, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                Icon(Icons.access_time, size: 17, color: task.numberOfTasks > 0 ? Colors.blue : null),
                Text(' ${task.allTime.getTimeFormated()}', style: const TextStyle(fontSize: 15)),
                const Spacer(),
                Icon(Icons.task_alt, size: 17,color: task.numberOfTasks > 0 ? Colors.lightGreen : null),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 5),
                  child: Text('${task.numberOfTasks}', style: const TextStyle(fontSize: 15)),
                ),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}

class PartnerTileSceleton extends StatelessWidget {
  final double height;
  final double width;

  const PartnerTileSceleton(this.height, this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * height,
      width: Get.width * width,
      child: Card(
      elevation: 5,
      child: Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            child: SceletonWidget(Get.height * height * 0.2, Get.width * width * 0.87),
          ),
          SceletonWidget(Get.height * height * 0.2, Get.width * width * 0.35),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                SceletonWidget(Get.height * height * 0.2, Get.width * width * 0.6),
                const Spacer(),
                SceletonWidget(Get.height * height * 0.2, Get.width * width * 0.15)
              ],
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }
}

class SceletonWidget extends StatelessWidget {
  final double height;
  final double width;

  const SceletonWidget(this.height, this.width, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(5))
        )
    );
  }
}



