import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/services/user_preference.dart';

class NetworkCaller {
  // get  method =========================================================
  static Future<NetworkResponse> getRequest(
    String url, {
    bool requiresAuth = false,
  }) async {
    try {
      debugPrint('=== Starting API request to: $url ===');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add authorization header if required
      final String? token = await UserPreference.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        debugPrint('=== Added Authorization header with token ===');
      }

      debugPrint('=== Request headers: $headers ===');

      debugPrint('=== Sending GET request to: $url ===');
      Response response = await get(Uri.parse(url), headers: headers);
      debugPrint(
        '=== Response received with status code: ${response.statusCode} ===',
      );

      if (response.statusCode == 200) {
        debugPrint(
          '=== Response body (first 100 chars): ${response.body.length > 100 ? response.body.substring(0, 100) + "..." : response.body} ===',
        );
        try {
          final decodedData = jsonDecode(response.body);
          debugPrint('=== Successfully decoded JSON response ===');
          return NetworkResponse(
            statusCode: response.statusCode,
            isSuccess: true,
            responsData: decodedData,
          );
        } catch (e) {
          debugPrint('=== JSON decode error: $e ===');
          debugPrint(
            '=== Response body that failed to decode: ${response.body} ===',
          );
          return NetworkResponse(
            statusCode: response.statusCode,
            isSuccess: false,
            errorMessage: 'Failed to decode response: ${e.toString()}',
          );
        }
      } else {
        debugPrint(
          '=== Request failed with status: ${response.statusCode} ===',
        );
        debugPrint('=== Response body: ${response.body} ===');
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMessage:
              'Request failed with status: ${response.statusCode}, body: ${response.body}',
        );
      }
    } on Exception catch (e) {
      debugPrint('=== Network exception: $e ===');
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: 'Network exception: ${e.toString()}',
      );
    } catch (e) {
      debugPrint('=== Unexpected error during network call: $e ===');
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  // post method =========================================
  static Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      debugPrint('url: $url');
      debugPrint('body: $body');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add authorization header if required
      final String? token = await UserPreference.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        debugPrint('=== Added Authorization header with token ===');
      }

      Response response = await post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

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
          errorMessage: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Network error: $e');
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: 'Network error: ${e.toString()}',
      );
    }
  }
}
