import 'dart:async';
import 'dart:convert'; // For JSON support
import 'package:http/http.dart' as http;


class LbryBaseApi {
  static int _requestId = 0;

  /// Makes an HTTP request
  ///
  /// Sends a JSON-RPC 2.0 POST request to [url] specifying that
  /// it wants to perform the function [method] with the parameters
  /// [params] using the username and password pair [basicAuth]
  /// and times out after [timeout] seconds
  static Future<Map> _makeRequest(String url, String method,
      {Map<String, dynamic> params = const {}, List<String> basicAuth,
      num timeout = 600.0}) async {

    // Creates a map for the body of the request
    Map body = {"method": method, "params": params,
                "jsonrpc": "2.0", "id": ++LbryBaseApi._requestId};

    String jsonData = jsonEncode(body);

    Map<String, String> headers = {
      "Content-Type": "application/json-rpc",
      "user-agent": "LBRY Dart 2.0.0 API"
    };

    // await for the http response to be returned
    http.Response response = await http.post(url,
        headers: headers,
        body: jsonData
    );

    return jsonDecode(response.body);
  }

}