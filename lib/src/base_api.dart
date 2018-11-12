import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class LbryBaseApi {
  // Static ID to keep track of each request being sent
  static int _requestId = 0;
  int get requestId => _requestId;

  /**
   * Makes an HTTP request to the specified LBRY URL
   *
   * Sends a JSON-RPC 2.0 POST request to [url] specifying that
   * it wants to perform the function [method] with the parameters
   * [params] using the username and password pair [basicAuth]
   * and times out after [timeout] seconds. If the server
   * responds with an error, [LbryException] is thrown.
   */
  static Future<Map> makeRequest(String url, String method,
      {Map<String, dynamic> params = const {},
      String basicAuthString, int timeout = 600}) async {

    // Creates a map for the body of the request
    Map body = {
      "method": method,
      "params": params,
      "jsonrpc": "2.0",
      "id": ++LbryBaseApi._requestId
    };

    // Formats the body map as a JSON Serialized String
    String jsonData = jsonEncode(body);

    // Create the headers for the POST Request
    Map<String, String> headers = {
      "Content-Type": "application/json-rpc",
      "user-agent": "LBRY Dart 2.0.0 API"
    };

    // If we were provided with a basicAuthString then put it in headers
    if (basicAuthString != null) {
      headers['Authorization'] = basicAuthString;
    }

    // Initialize the map to store response
    Map jsonResponse;

    try {
      // await for the http response to be returned
      http.Response response = await http
          .post(url, headers: headers, body: jsonData)
          .timeout(Duration(seconds: timeout.abs()));

      // Turn JSON String into a Dart Map object
      jsonResponse = jsonDecode(response.body);
    } catch (error) {
      print(jsonResponse);

      if (error is TimeoutException) {
        jsonResponse = {
          "error": {
            "type": "timeout",
            "message": "Server timed out after ${timeout} secs",
            "code": 408 // Timeout code
          }
        };
      } else {
        /* uses 2^15 as the error code for an unknown error
         since LBRY's server error codes are 16 bit signed integers,
          so 2^15 is a number that can never be returned from LBRY
         */
        jsonResponse = {
          "error": {
            "type": "unknown",
            "message": "${error.toString()}",
            "code": 32768
          }
        };
      }
    } finally {
      return jsonResponse;
    }
  }
}
