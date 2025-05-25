import 'dart:convert';

import 'package:http/http.dart';
import 'package:tournament_app/network/network_response.dart';

class NetworkCaller {
  // get  method =========================================================
  static Future<NetworkResponse> getRequest(String url) async {
    try {
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responsData: decodedData,
        );
      } else {
        return NetworkResponse(statusCode: 200, isSuccess: false);
      }
    } on Exception catch (e) {
      // TODO
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  // post method =========================================
  static Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      print('url: $url');
      print('body: $body');

      Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responsData: decodedData,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage:
              'Failed to create account. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Network error: $e');
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: 'Network error: ${e.toString()}',
      );
    }
  }
}
