import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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
  LbrycrdApi(String username, String password, {this.timeout = 600}) :
      _basicAuthString = makeBasicAuth(username, password);


  static String makeBasicAuth(String username, String password) {
    Latin1Encoder latin1Encoder;

    Uint8List bytesUser = latin1Encoder.convert(username),
              bytesPass = latin1Encoder.convert(password),
              sep = latin1Encoder.convert(':');

    Uint8List bytes = bytesUser + sep + bytesPass;

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
        params: params, basicAuth: _basicAuth, timeout: timeout);

    if (response.containsKey("error")) {
      throw (LbryException(response));
    }

    return response;
  }
}
