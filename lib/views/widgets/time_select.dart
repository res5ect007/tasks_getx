import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/extensions.dart';
import '../../controllers/period_controller.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';

// ignore: must_be_immutable
class BottomSheetTimeSelect extends StatefulWidget {
  bool detailed;
  TaskElement? task;

  BottomSheetTimeSelect({Key? key, this.detailed = false, required this.task}) : super(key: key);

  @override
  BottomSheetAnimationState createState() => BottomSheetAnimationState();
}

class BottomSheetAnimationState extends State<BottomSheetTimeSelect>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final TaskController taskController = Get.put(TaskController());
  final PeriodController periodController = Get.put(PeriodController());

  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(seconds: 1);
    controller.reverseDuration = const Duration(seconds: 1);
    controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20))),
              context: context,
              transitionAnimationController: controller,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: SizedBox(
                    height: 255,
                    child: TimeWidget(
                        periodController: periodController,
                        taskController: taskController,
                        detailed: widget.detailed,
                        task: widget.task),
                  ),
                );
              });
        },
        child: Text(
              '${periodController.convertPeriodToText(widget.task == null ? periodController.periodData[periodController.selectedPeriodIndex] : widget.task?.doneDate, false, widget.detailed)}',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w600))
      );
  }
}

class TimeWidget extends StatelessWidget {
  final TaskController taskController;
  final PeriodController periodController;
  final bool detailed;
  final TaskElement? task;

  const TimeWidget(
      {Key? key, required this.taskController, required this.periodController, required this.detailed, required this.task})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimePickerWidget(
      minDateTime: DateTime(periodController.periodData[0].year, 01, 01),
      maxDateTime: DateTime(periodController.periodData[periodController.periodData.length - 1].year, 12, 31),
      initDateTime: task == null ? periodController.periodData[periodController.selectedPeriodIndex] : task?.doneDate,
      locale: getCurrentDateTimePickerLocale(),
      dateFormat: detailed == true ? 'dd, MMMM, yyyy' : 'MMMM, yyyy',
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.transparent,
        itemTextStyle: TextStyle(color: ThemeData().primaryColor),
        confirmTextStyle: TextStyle(
            color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white, fontSize: 17),
        cancelTextStyle: TextStyle(
            color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white, fontSize: 17),
      ),
      onConfirm: (dateTime, number) async {
       if (detailed) {
         task?.doneDate = dateTime;
       }
       else  {
          int index = periodController.periodData.keys.firstWhere(
                  (key) => periodController.periodData[key] == dateTime,
              orElse: () => periodController.selectedPeriodIndex.value);
          if (periodController.selectedPeriodIndex.value != index) {
            periodController.selectedPeriodIndex.value = index;
            taskController.fetchTasks();
          }
        }
      },
      onChange: (dateTime, number) {
        HapticFeedback.vibrate();
      },
    );
  }
}

