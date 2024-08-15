import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class NetworkApiServices {
  final box = GetStorage();

  Future getApi(String url) async {
    String token = box.read('token').toString();

    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        "authorization": 'Bearer $token'
      });
      responseJson = returnRespose(response);
    } catch (e) {
      throw (responseJson['message']);
    }
    return responseJson;
  }

  Future<dynamic> postApi(dynamic data, String url) async {
    dynamic responseJson;
    String token = box.read('token').toString();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          // "Authorization": token == "null" ? authToken : 'Bearer $token'
        },
      ).timeout(Duration(seconds: 60));

      responseJson = returnResponse(response);
    } on SocketException {
      throw SocketException("No Internet");
    } catch (e) {
      // Log or handle the error appropriately
      throw Exception('Error occurred: $e');
    }

    if (responseJson == null) {
      throw Exception('Response is null');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad request');
      case 401:
      case 403:
        throw Exception('Unauthorized');
      case 500:
      default:
        throw Exception(
            'Error occurred while communicating with server with status code: ${response.statusCode}');
    }
  }

  Future updateApi(dynamic data, String url, String authToken) async {
    dynamic responseJson;
    String token = box.read('token').toString();

    try {
      final response =
          await http.put(Uri.parse(url), body: jsonEncode(data), headers: {
        'Content-type': 'application/json',
        "Authorization": token == "null" ? authToken : 'Bearer $token'
      }).timeout(Duration(seconds: 15));

      responseJson = returnRespose(response);
    } on SocketException {
      throw SocketException("No Internet");
    } catch (e) {
      throw (responseJson['message']);
    }
    return responseJson;
  }

  Future deleteApi(String url) async {
    String token = box.read('token').toString();

    dynamic responseJson;
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        "authorization": 'Bearer $token'
      }).timeout(Duration(seconds: 15));
      responseJson = returnRespose(response);
    } on SocketException {
      throw SocketException("No Internet");
    } catch (e) {
      throw (responseJson['message']);
    }
    return responseJson;
  }
}

returnRespose(http.Response response) async {
  log("res body ${response.body.toString()}");
  print("res s code ${response.statusCode.toString()}");
  print("res head${response.headers.toString()}");
  // print("url otp ${AppUrl.otpApi.toString()}");
  // print("phrasebook url ${AppUrl.getPhrasebookApi}");
  // print("phrases details url ${AppUrl.getPhrasesApi}");

  switch (response.statusCode) {
    case 200:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 201:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 400:
      dynamic responseJson = jsonDecode(response.body);

      throw (responseJson['message']);

    case 500:
      dynamic responseJson = jsonDecode(response.body);

      throw (responseJson['message']);

    // default:
    //   dynamic responseJson = jsonDecode(response.body);

    //   throw (responseJson['message']);
  }
}
