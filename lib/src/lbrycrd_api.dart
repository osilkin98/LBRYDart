import 'dart:async';
import 'base_api.dart';


class LbrycrdApi extends LbryBaseApi {
  final int timeout;
  static const String url = "http://localhost:9245";
  List<String> _basicAuth;

  /// Constructs a LBRYCRD API object
  ///
  /// Uses the credentials [_basicAuth] to log into the
  /// lbrycrd network, and sets it to timeout after [timeout]
  /// seconds of unresponsiveness. The default is 600 seconds.
  LbrycrdApi(this._basicAuth,  {this.timeout = 600});

  LbrycrdApi.credentials(String username, String password,
      {this.timeout = 600}) : _basicAuth = [username, password];

  /// Makes a call to the LBRYCRD API
  ///
  /// Invokes a call to the [method] function with parameters
  /// [params] in the LBRYCRD API, and the username and
  /// password pair [_basicAuth] to authenticate. The client
  /// waits for [timeout] seconds before giving up.
  /// If the API experiences an error, [LbryException] is thrown.
  Future<Map> call(method, {Map<String, dynamic> params = const {},
      int timeout = -1}) async {
    timeout = timeout > -1 ? this.timeout : timeout;

    Map response = await LbryBaseApi.makeRequest(url, method,
        params: params, basicAuth: _basicAuth, timeout: timeout);

    return response;
  }
}