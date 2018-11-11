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
  static Future<Map> makeRequest(String url, String method,
      {Map<String, dynamic> params = const {}, List<String> basicAuth,
      num timeout = 600.0}) async {
    /*
    String paramString = '';

    if(params != null) {

      params.forEach((param, value){
        paramString += '"${param}": "${value}",';
      });
    }*/

    Map body = {"method": method, "params": params,
                "jsonrpc": "2.0", "id": ++LbryBaseApi._requestId};


    String data = jsonEncode(body);

    Map<String, String> headers = {
      "Content-Type": "application/json-rpc",
      "user-agent": "LBRY Dart 2.0.0 API"
    };

    http.Response response = await http.post(url, headers: headers, body: data);
    
    return jsonDecode(response.body);
  }

}