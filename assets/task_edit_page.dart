import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/extensions.dart';
import '../lib/controllers/period_controller.dart';
import '../lib/controllers/task_controller.dart';

class TaskEditPage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final PeriodController periodController = Get.put(PeriodController());

  TaskEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
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
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 2,bottom: 5),
            child: Row(
              children: [
                const Spacer(),
                const Icon(Icons.access_time, size: 20),
                Text( taskController.tasksMap[taskController.selectedPartner] == null ?
                ' 0 ${'hh'.tr} 0 ${'mm'.tr}' : ' ${taskController.tasksMap[taskController.selectedPartner]?.allTime.getTimeFormated()}',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    DateTime maxDateTime = periodController.periodData[periodController.periodData.length - 1];
                    maxDateTime = DateTime(maxDateTime.year, 12, 31);

                    DateTime minDateTime =  periodController.periodData[0];
                    minDateTime = DateTime(minDateTime.year, 01, 01);

                    // DatePicker.showDatePicker(context,
                    //       showTitleActions: true,
                    //     currentTime: periodController.periodData[periodController.selectedPeriodIndex],
                    //     locale: LocaleType.ru,
                    //       minTime: minDateTime,
                    //       maxTime: maxDateTime,
                    //        onChanged: (date) {
                    //          HapticFeedback.vibrate();
                    //       },
                    //     onConfirm: (date) {
                    //
                    //       },
                    //     theme: DatePickerTheme(containerHeight: 210,
                    //         backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.white : Colors.black ,
                    //         itemStyle: TextStyle(color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white),
                    //         titleHeight: 40)
                    //       );

                    // showTimePicker(context: context, initialTime: TimeOfDay.now());
                    // showDateRangePicker(
                    //     context: context, firstDate: periodController.periodData[0], lastDate: periodController.periodData[periodController.periodData.length - 1]);
                    // showDatePicker(context: context,
                    //     initialDate: periodController.periodData[periodController.selectedPeriodIndex],
                    //     firstDate: periodController.periodData[0],
                    //     lastDate: periodController.periodData[periodController.periodData.length - 1]);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: false,
                              content: DateTimePickerWidget(
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
                                    fontSize: 17),),
                              onConfirm:  (dateTime, number) async {
                                int index = periodController.periodData.keys.firstWhere((key) => periodController.periodData[key] == dateTime,
                                    orElse: () => periodController.selectedPeriodIndex);
                                if (periodController.selectedPeriodIndex.value != index) {
                                  periodController.selectedPeriodIndex.value = index;
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
          ],
      );
    }),
    );
  }
}
