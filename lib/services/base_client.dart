import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tasks_getx/services/app_exeptions.dart';
import '../models/task.dart';

class BaseClient {
  static const int TIME_OUT_DURATION = 10;

  //GET
  Future<dynamic> get(String baseUrl, String api, String userName, String password) async {
    var uri = Uri.parse(baseUrl + api,);
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$userName:$password'))}';

    try {
      var response =
          await http.get(uri, headers: <String, String>{'authorization': basicAuth}).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //POST
  Future<dynamic> post(String baseUrl, String api, String userName, String password, dynamic payloadObj) async {
    var uri = Uri.parse(baseUrl + api);
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$userName:$password'))}';
    var payload = json.decode(payloadObj);

    try {
      var response =
          await http.post(uri, headers: <String, String>{'authorization': basicAuth}).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: //OK
        var responseJson = utf8.decode(response.bodyBytes);
        return taskFromJson(responseJson);
      case 400: //Bad Request
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request?.url.toString());
      case 401: //Unauthorized
      case 403: //Forbidden
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request?.url.toString());
      case 500: //Internal Server Error
      default:
        throw FetchDataException(
            'Error occured with code: ${response.statusCode}',
            response.request?.url.toString());
    }
  }
}