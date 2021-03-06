import 'dart:async';
import 'dart:convert';

import 'base_api.dart';
import 'exceptions.dart';

class LbrycrdApi extends LbryBaseApi {
  /* Basic Variables */
  final int timeout;
  final String _basicAuthString;
  static const String url = "http://localhost:9245";

  /**
   * Constructs a LBRYCRD API object
   *
   * Uses the credentials [_basicAuth] to log into the
   * lbrycrd network, and sets it to timeout after [timeout]
   * seconds of unresponsiveness. The default [timeout] is 600 seconds.
   */
  LbrycrdApi(String username, String password, {this.timeout = 600})
      : _basicAuthString = makeBasicAuth(username, password);

  static String makeBasicAuth(String username, String password) {
    Utf8Encoder UTF8 = Utf8Encoder();

    List<int> bytes = UTF8.convert(username + ':' + password);

    String encodedAuth = Base64Encoder().convert(bytes);

    return "Basic " + encodedAuth;
  }

  /**
   * Makes a call to the LBRYCRD API
   *
   * Invokes a call to the [method] function with parameters
   * [params] in the LBRYCRD API, and the username and
   * password pair [_basicAuth] to authenticate. The client
   * waits for [timeout] seconds before giving up.
   * If the response from the API contains an error,
   * then [LbryException] is thrown.
   */
  Future<Map> call(method,
      {Map<String, dynamic> params = const {}, int timeout = 0}) async {
    timeout = timeout > 0 ? timeout : this.timeout;

    Map response = await LbryBaseApi.makeRequest(url, method,
        params: params, basicAuthString: _basicAuthString, timeout: timeout);

    if (response.containsKey("error")) {
      throw (LbryException(response));
    }

    return response;
  }
}
