import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tasks_getx/services/extensions.dart';

class PeriodController extends GetxController {
  var selectedPeriodIndex = 0.obs;
  var isVisibleInPartners = false.obs;
  var periodData = {}.obs;
  var periodAllData = {}.obs;
  final String currentLocale = Get.deviceLocale!.languageCode;

  @override
  void onInit() {
    initializeDateFormatting(currentLocale, null);
    getPeriodData();
    super.onInit();
  }

  getPeriodData() {
    DateTime now = DateTime.now();
    DateTime currentPeriod = DateTime(now.year, now.month, 1);

    int j = 1;
    for (int i = 0; i < 60; i++){
      DateTime indexPeriod = DateTime(now.year, now.month + i - 30, 1);

      periodData[i] = indexPeriod;

      if (indexPeriod == currentPeriod) {
        selectedPeriodIndex.value = i;
      }

      DateTime indexAllPeriod = indexPeriod;
      int day = 1;

      while (indexPeriod == DateTime(indexAllPeriod.year, indexAllPeriod.month, 1)) {
        indexAllPeriod = DateTime(indexAllPeriod.year, indexAllPeriod.month, day);

        if (indexPeriod == DateTime(indexAllPeriod.year, indexAllPeriod.month, 1)) {
          periodAllData[j] = indexAllPeriod;
          j++;
        }

        day++;
      }
    }

  }

  convertPeriodToText(DateTime date, [bool substring = true, bool detailed = false]) {
    String period;

    if (detailed) {
      period = DateFormat.yMMMEd(currentLocale).format(date);
    } else {
      String month = DateFormat.MMM(currentLocale).format(date);
      month = substring
          ? month.toCapitalized().substring(0, 3)
          : month.toCapitalized();
      String year = DateFormat.y(currentLocale).format(date);
      period = '$month $year';
    }
    return period;
  }
}
