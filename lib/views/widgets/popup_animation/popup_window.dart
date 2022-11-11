import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/models/task.dart';
import 'package:tasks_getx/services/extensions.dart';
import '../../../controllers/period_controller.dart';
import '../../../controllers/task_controller.dart';
import '../time_select.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class PopupWindow extends StatelessWidget {
  const PopupWindow({Key? key, required this.tapWidget, required this.popupWidget, required this.heroTag}) : super(key: key);

  final Widget tapWidget;
  final Widget popupWidget;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(builder: (context) {
          return popupWidget;
        }));
      },
      child: Hero(
        tag: heroTag,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin as Rect, end: end as Rect);
        },
        child: tapWidget,
      ),
    );
  }
}


/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class AddPopupCard extends StatefulWidget {

  AddPopupCard({Key? key, required this.heroTag, required this.task}) : super(key: key);
  final String heroTag;
  late TaskElement? task;

  @override
  State<AddPopupCard> createState() => _AddPopupCardState();
}

class _AddPopupCardState extends State<AddPopupCard> {

  final TaskController taskController = Get.put(TaskController());
  final PeriodController periodController = Get.put(PeriodController());
  late TextEditingController discriptionController;
  late TextEditingController commentController;
  late TextEditingController statusController;

  @override
  void initState() {
    discriptionController = TextEditingController(text: widget.task?.discription);
    commentController = TextEditingController(text: widget.task?.comment);
    statusController = TextEditingController(text: widget.task == null ? 'status_done'.tr : widget.task?.status);
    //doneDateController = DateTimeE
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Hero(
          tag: widget.heroTag,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin as Rect, end: end as Rect);
          },
          child: Material(
            color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.blue[200] : Colors.blueGrey[800] ,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      DropdownButton(
                        value: statusController.text,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 5,
                        dropdownColor: Colors.blue,
                        icon: Icon(statusController.text.getIconForStatus(), size: 17, color: statusController.text.getIconColorForStatus()),
                        hint: Text('status'.tr),
                        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),
                        items: taskStatus.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),);
                            },).toList(),
                        onChanged: (value) {
                          setState(() {
                            statusController.text = value as String;
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      BottomSheetTimeSelect(detailed: true, task: widget.task),
                    ]),
                     TextFormField(
                       controller: discriptionController,
                       maxLines: 10,
                      minLines: 3,
                      decoration: InputDecoration(
                        hintText: 'new_task'.tr,
                        border: InputBorder.none,
                      ),
                      //cursorColor: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                    const Divider(
                      //color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white,
                      thickness: 1,
                    ),
                    TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'comment'.tr,
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.white,
                      minLines: 1,
                      maxLines: 5,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.task?.status = statusController.text.trim();
                        widget.task?.discription = discriptionController.text.trim();
                        widget.task?.comment = commentController.text.trim();
                        //widget.task?.doneDate = doneDateController.text.trim();
                        Get.back();
                      },
                      child: Text('ok'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
