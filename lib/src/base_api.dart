import 'dart:async';
import 'dart:convert'; // For JSON support
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class LbryBaseApi {
  static int _requestId = 0;

  /// Makes an HTTP request to the specified LBRY URL
  ///
  /// Sends a JSON-RPC 2.0 POST request to [url] specifying that
  /// it wants to perform the function [method] with the parameters
  /// [params] using the username and password pair [basicAuth]
  /// and times out after [timeout] seconds
  @protected
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

    Map jsonResponse;

    try {
      // await for the http response to be returned
      http.Response response = await http
          .post(url, headers: headers, body: jsonData)
          .timeout(Duration(seconds: timeout));
      jsonResponse = jsonDecode(response.body);
    } catch (error) {
      jsonResponse = {
        "error": {
          "type": "timeout",
          "message": "Server timed out after ${timeout} secs"
        }
      };
    } finally {
      return jsonResponse;
    }
  }
}
