import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tasks_getx/helper/dialog_helper.dart';
import 'package:tasks_getx/services/app_exeptions.dart';

class ErrorController {
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      // var message = error.message;
      // DialogHelper.showErrorDialog(description: message);
      Get.toNamed('/no_connection');
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErrorDialog(
          description: 'Oops! It took longer to respond.');
    }
  }

  showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }
}