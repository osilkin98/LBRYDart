import 'dart:async';
import 'dart:convert';
import 'base_api.dart';


class LbrydApi extends LbryBaseApi {
  final int timeout;
  static final String _lbrydUrl = "http://localhost:5279";

  LbrydApi(this.timeout);

  Future<Map> call(String method,
      {Map<String, dynamic> params = const {}, int timeout = -1}) async {
    
    timeout = timeout >= 0 ? this.timeout : timeout;
    return LbryBaseApi.makeRequest(_lbrydUrl, method,
        params: params, timeout: timeout);
    
  }

}