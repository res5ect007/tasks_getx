import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tasks_getx/controllers/task_controller.dart';
import 'package:tasks_getx/views/widgets/period_tile.dart';
import '../../controllers/period_controller.dart';
import '../widgets/bottom_logo.dart';
import '../widgets/partner_tile.dart';

class HomePage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final PeriodController periodController = Get.put(PeriodController());
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final GetStorage box = GetStorage();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/user_avatar2.png'),
            backgroundColor: Colors.transparent,
            radius: 22,
          ),
        ),
        title: Text(box.read('userName')?.replaceAll(' ', '\n'),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        actions: [ Directionality(
          textDirection: TextDirection.rtl,
          child: Obx(() {
            return ElevatedButton.icon(
                onPressed: () {
                  periodController.isVisibleInPartners.toggle();
                  Timer(periodController.isVisibleInPartners.isFalse
                      ? const Duration(milliseconds: 500)
                      : const Duration(milliseconds: 0), () {
                    itemScrollController.scrollTo(
                        index: periodController.selectedPeriodIndex.value - 2,
                        curve: Curves.easeInOutCubic,
                        duration: const Duration(milliseconds: 1500));
                  });
                },
                icon: Icon(periodController.isVisibleInPartners.isFalse
                    ? Icons.calendar_month : Icons
                    .calendar_month_outlined, size: 28),
                label: Text(periodController.convertPeriodToText(
                    periodController.periodData[periodController
                        .selectedPeriodIndex])
                    .replaceAll(' ', '\n') ?? '...\n2999',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11.0))
                    ),

                  ),
            );
          }),
        ),

        ],
       //backgroundColor: Colors.transparent,
      ),
      body:Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
              //   child: Row(
              //     children: [
              //       const CircleAvatar(
              //         backgroundImage: AssetImage('assets/user_avatar2.png'),
              //         backgroundColor: Colors.transparent,
              //         radius: 22,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 5),
              //         child: Text(box.read('userName')?.replaceAll(' ', '\n'),
              //             style: const TextStyle(fontWeight: FontWeight.w600)),
              //       ),
              //       const Spacer(),
              //       Directionality(
              //         textDirection: TextDirection.rtl,
              //         child: Obx(() {
              //           return ElevatedButton.icon(
              //               onPressed: () {
              //                 periodController.isVisibleInPartners.toggle();
              //                 Timer(periodController.isVisibleInPartners.isFalse
              //                     ? const Duration(milliseconds: 500)
              //                     : const Duration(milliseconds: 0), () {
              //                   itemScrollController.scrollTo(
              //                       index: periodController.selectedPeriodIndex
              //                           .value - 2,
              //                       curve: Curves.easeInOutCubic,
              //                       duration: const Duration(milliseconds: 1500));
              //                 });
              //               },
              //               icon: Icon(periodController.isVisibleInPartners.isFalse
              //                   ? Icons.calendar_month : Icons
              //                   .calendar_month_outlined, size: 28),
              //               label: Text(periodController.convertPeriodToText(
              //                   periodController.periodData[periodController
              //                       .selectedPeriodIndex])
              //                   .replaceAll(' ', '\n') ?? '...\n2999',
              //                   textAlign: TextAlign.center,
              //                   style: const TextStyle(fontWeight: FontWeight.w600))
              //           );
              //         }),
              //       )
              //     ],
              //   ),
              // ),
              Obx(() {
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: periodController.isVisibleInPartners.isTrue ? Get
                        .height * 0.09 : 0,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                       width: Get.width,
                       height: Get.height * 0.06,
                      child: ScrollablePositionedList.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (periodController.selectedPeriodIndex.value !=
                                  index) {
                                periodController.selectedPeriodIndex.value = index;
                                taskController.fetchTasks();
                              } else {
                                periodController.selectedPeriodIndex.value = index;
                              };
                            },
                            child: Obx(() {
                              return PeriodTile(
                                  periodController.convertPeriodToText(
                                      periodController
                                          .periodData[index] as DateTime)
                                      ?.replaceAll(' ', '\n'), 0.05, 0.165,
                                  periodController.selectedPeriodIndex.value ==
                                      index);
                            }
                            ),
                          );
                        },
                        itemCount: periodController.periodData.length,
                        scrollDirection: Axis.horizontal,
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                      ),
                    )
                );
              }),
              //const GradientLine(),
            Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 12),
                  child: Text('clients'.tr, style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w600))),
              Expanded(child: Obx(() {
                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: refresh,
                      child: taskController.isLoading.isTrue
                          ? GridView.builder(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 4.4 / 2,
                            // crossAxisSpacing: 1,
                            // mainAxisSpacing: 5
                          ),
                          itemCount: 16,
                          itemBuilder: (BuildContext ctx, index) {
                            return const PartnerTileSceleton(0.1, 0.5);
                          })
                          : GridView.builder(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 4.4 / 2,
                            // crossAxisSpacing: 1,
                            // mainAxisSpacing: 5
                          ),
                          itemCount: taskController.taskList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                                onTap: () {
                                  taskController.selectedPartner.value = taskController.taskList[index].partner;
                                  taskController.partnerTasks.value = taskController.tasksMap[taskController.taskList[index].partner]!.tasks ;
                                  Get.toNamed('/task');
                                },
                                child: PartnerTile(
                                    taskController.taskList[index], 0.1, 0.5));
                          }),
                    ),
                    Positioned(
                      bottom: 0,
                      height: 30,
                      width: Get.width,
                      child: Container(
                              decoration: const BoxDecoration(gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black26, Colors.black45, Colors.black87],
                              )),
                              child:  Column(
                                children: [
                                  const Spacer(),
                                  taskController.isLoading.isTrue ?
                                  Shimmer.fromColors(
                                      baseColor: Colors.lightBlue,
                                      highlightColor: Colors.indigoAccent,
                                      child:  const Bottom()) : const Bottom(),
                                ],),
                      ),
                    )],
                );
              })
              ),
            ],)
    );
  }
}

Future refresh() async {
  final TaskController taskController = Get.put(TaskController());
  taskController.fetchTasks();
}