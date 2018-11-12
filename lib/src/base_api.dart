import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class LbryBaseApi {
  static int _requestId = 0;

  int get requestId => _requestId;


  static String makeBasicAuth(String username, String password) {
    Latin1Encoder latin1encoder;
    Uint8List latinUser = latin1encoder.convert(username),
              latinPass = latin1encoder.convert(password);




    }
  }


  /// Makes an HTTP request to the specified LBRY URL
  ///
  /// Sends a JSON-RPC 2.0 POST request to [url] specifying that
  /// it wants to perform the function [method] with the parameters
  /// [params] using the username and password pair [basicAuth]
  /// and times out after [timeout] seconds. If the server
  /// responds with an error, [LbryException] is thrown.
  static Future<Map> makeRequest(String url, String method,
      {Map<String, dynamic> params = const {},
      List<String> basicAuth,
      int timeout = 600}) async {
    // Creates a map for the body of the request
    Map body = {
      "method": method,
      "params": params,
      "jsonrpc": "2.0",
      "id": ++LbryBaseApi._requestId
    };

    String jsonData = jsonEncode(body);

    Map<String, String> headers = {
      "Content-Type": "application/json-rpc",
      "user-agent": "LBRY Dart 2.0.0 API"
    };

    // We need to format the basic authentication
    if(basicAuth.length == 2) {
      String username = basicAuth[0], password = basicAuth[1];


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
