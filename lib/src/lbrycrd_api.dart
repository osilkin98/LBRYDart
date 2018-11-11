import 'dart:async';
import 'base_api.dart';


class LbrycrdApi extends LbryBaseApi {
  final int timeout;
  static const String url = "http://localhost:9245";
  List<String> _basicAuth;

  LbrycrdApi(this._basicAuth,  {this.timeout = 600});

  LbrycrdApi.credentials(String username, String password,
      {this.timeout = 600}) : _basicAuth = [username, password];

  Future<Map> call(method, {Map<String, dynamic> params = const {},
      int timeout = -1}) async {
    timeout = timeout > -1 ? this.timeout : timeout;

    return LbryBaseApi.makeRequest(url, method,
        params: params, basicAuth: _basicAuth, timeout: timeout);
  }
}