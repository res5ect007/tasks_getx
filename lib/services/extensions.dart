import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  double numberOfStringInTile() {
    double value = length / 35;
    value = value == 0 ? 1 : value;
    return value;
  }

  IconData getIconForStatus() {
    switch (this) {
      case 'Выполнено':
        return Icons.done_all;
      case 'Отменено':
        return Icons.cancel;
      case 'Отложено':
        return Icons.timelapse;
      case 'Тестируется':
        return Icons.people_rounded;
      case 'В разработке':
        return Icons.developer_mode;
      default:
        return Icons.developer_mode;
    }
  }

  Color? getIconColorForStatus() {
    switch (this) {
      case 'Выполнено':
        return Colors.green[700];
      case 'Отменено':
        return Colors.red[800];
      case 'Отложено':
        return Colors.yellow[700];
      case 'Тестируется':
        return Colors.blue;
      case 'В разработке':
        return Colors.yellow[700];
      default:
        return Colors.yellow[700];
    }
  }
}

extension TimeFormated on int {
  getTimeFormated() {

    if (this == 0) {
      return '0 ${'hh'.tr} 0 ${'mm'.tr}';
    }

    DateTime now = DateTime.now();
    DateTime allTime = DateTime(now.year, now.month, 1).add(Duration(seconds: this));

    String hours = DateFormat.H().format(allTime);
    hours = hours == '00' ? '' : '$hours ${'hh'.tr}';

    String minutes = DateFormat.m().format(allTime);
    minutes = minutes == '00' ? '' : '$minutes ${'mm'.tr}';

    return '$hours $minutes';
  }
}

extension DateFormated on DateTime {
  getDateFormated() => DateFormat('dd-MM-yyyy').format(this);
}

getCurrentDateTimePickerLocale() {
    switch (Get.deviceLocale?.languageCode) {
      case 'en':
        return DateTimePickerLocale.en_us;
      case 'uk':
        return DateTimePickerLocale.uk;
      case 'ru':
        return DateTimePickerLocale.ru;
      default:
        return DateTimePickerLocale.en_us;
    }
}


