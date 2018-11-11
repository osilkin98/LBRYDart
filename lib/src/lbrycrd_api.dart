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

  Future<Map> call(method, {Map<String, dynamic> params = const {},
      int timeout = -1}) async {
    timeout = timeout > -1 ? this.timeout : timeout;

    Map response = await LbryBaseApi.makeRequest(url, method,
        params: params, basicAuth: _basicAuth, timeout: timeout);

    return response;
  }
}