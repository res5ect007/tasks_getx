import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/extensions.dart';
import '../../controllers/period_controller.dart';
import '../../controllers/task_controller.dart';


class BottomSheetTimeSelect extends StatefulWidget {
  bool detailed;

  BottomSheetTimeSelect({Key? key, this.detailed = false}) : super(key: key);

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

    DateTime maxDateTime = periodController
        .periodData[periodController.periodData.length - 1];
    maxDateTime = DateTime(maxDateTime.year, 12, 31);

    DateTime minDateTime = periodController.periodData[0];
    minDateTime = DateTime(minDateTime.year, 01, 01);
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
                        detailed: widget.detailed),
                  ),
                );
              });
        },
        child: Text(
              '${periodController.convertPeriodToText(
                  periodController.periodData[periodController
                      .selectedPeriodIndex], false, widget.detailed)}',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w600))
      );
  }
}

class TimeWidget extends StatelessWidget {
  final TaskController taskController;
  final PeriodController periodController;
  final bool detailed;

  const TimeWidget(
      {Key? key, required this.taskController, required this.periodController, required this.detailed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime maxDateTime = periodController.periodData[periodController
        .periodData.length - 1];
    maxDateTime = DateTime(maxDateTime.year, 12, 31);
    DateTime minDateTime = periodController.periodData[0];
    minDateTime = DateTime(minDateTime.year, 01, 01);

    return DateTimePickerWidget(
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      initDateTime:
      periodController.periodData[periodController.selectedPeriodIndex],
      locale: getCurrentDateTimePickerLocale(),
      dateFormat: detailed == true ? 'dd, MMMM, yyyy' : 'MMMM, yyyy',
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.transparent,
        itemTextStyle: TextStyle(color: ThemeData().primaryColor),
        confirmTextStyle: TextStyle(
            color: MediaQuery
                .of(context)
                .platformBrightness ==
                Brightness.light ? Colors.black : Colors.white,
            fontSize: 17),
        cancelTextStyle: TextStyle(
            color: MediaQuery
                .of(context)
                .platformBrightness ==
                Brightness.light ? Colors.black : Colors.white, fontSize: 17),
      ),
      onConfirm: (dateTime, number) async {
        int index = periodController.periodData.keys.firstWhere(
                (key) => periodController.periodData[key] == dateTime,
            orElse: () => periodController.selectedPeriodIndex);
        if (periodController.selectedPeriodIndex.value != index) {
          periodController.selectedPeriodIndex.value = index;
          taskController.fetchTasks();}
      },
      onChange: (dateTime, number) {
        HapticFeedback.vibrate();
      },
    )
    ;
  }
}

