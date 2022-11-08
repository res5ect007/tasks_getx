import 'dart:convert';

import 'package:get/get.dart';

List<Task> taskFromJson(String str) => List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task({
    required this.partner,
    required this.author,
    required this.data,
    required this.allTime,
    required this.numberOfTasks,
    required this.oneTimeWork,
    required this.tasks,
    required this.id,
  });

  String partner;
  String author;
  DateTime data;
  int allTime;
  int numberOfTasks;
  bool oneTimeWork;
  List<TaskElement> tasks;
  String id;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    partner: json["Partner"],
    author: json["Author"],
    data: DateTime.fromMillisecondsSinceEpoch(json["Data"]*1000),
    allTime:  json["AllTime"],
    numberOfTasks:  json["NumberOfTasks"],
    oneTimeWork: json["OneTimeWork"],
    tasks: List<TaskElement>.from(json["Tasks"].map((x) => TaskElement.fromJson(x))),
    id: json["ID"],
  );

  Map<String, dynamic> toJson() => {
    "Partner": partner,
    "Author": author,
    "Data": data,
    "AllTime": allTime,
    "NumberOfTasks": numberOfTasks,
    "OneTimeWork": oneTimeWork,
    "Tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
    "ID": id,
  };

  // factory Task.createTask() => Task(
  //   partner: json["Partner"],
  //   author: json["Author"],
  //   data: DateTime.fromMillisecondsSinceEpoch(json["Data"]*1000),
  //   allTime:  json["AllTime"],
  //   numberOfTasks:  json["NumberOfTasks"],
  //   oneTimeWork: json["OneTimeWork"],
  //   tasks: List<TaskElement>.from(json["Tasks"].map((x) => TaskElement.fromJson(x))),
  //   id: json["ID"],
  // );
}

class TaskElement {
  TaskElement({
    required this.stringId,
    required this.status,
    required this.done,
    required this.doneDate,
    required this.discription,
    required this.time,
  });

  int stringId;
  String status;
  bool done;
  DateTime doneDate;
  String discription ;
  int time;

  factory TaskElement.fromJson(Map<String, dynamic> json) => TaskElement(
    stringId: json["StringID"],
    status: json["Status"],
    done: json["Done"],
    doneDate: DateTime.fromMillisecondsSinceEpoch(json["DoneDate"]*1000),
    discription: json["Discription"],
    time: json["Time"],
  );

  Map<String, dynamic> toJson() => {
    "StringID": stringId,
    "Status": status,
    "Done": done,
    "DoneDate": doneDate,
    "Discription": discription,
    "Time": time,
  };

  // TaskElement.createNewElement() {
  //   stringId,
  //   status,
  //   done,
  //   doneDate,
  //   discription,
  //   time,
  // }

  }

List<String> taskStatus = [
  'status_done'.tr,
  'status_canceled'.tr,
  'status_postponed'.tr,
  'status_testing'.tr,
  'status_developing'.tr
];

// enum TaskStatus {
//   completed,
//   testing,
//   developing,
//   canceled,
//   postpone
// }
//
// currentTaskStatus (value) {
//   switch (value) {
//     case 'Выполнено':
//       return TaskStatus.completed;
//     case 'Отменено':
//       return TaskStatus.canceled;
//     case 'Отложено':
//       return TaskStatus.postpone;
//     case 'Тестируется':
//       return TaskStatus.testing;
//     case 'В разработке':
//       return TaskStatus.developing;
//     default:
//       return TaskStatus.developing;
//   }
// }


