import 'dart:async';
import 'base_api.dart';

class LbrydApi extends LbryBaseApi {
  final int timeout;
  static const String url = "http://localhost:5279";

  /// Creates an instance of [LbrydApi]
  ///
  /// Creates an instance of [LbrydApi] to run on the
  /// set [url], and timeout after [timeout] seconds have
  /// passed since we've last made contact to the server.
  LbrydApi([this.timeout = 600]);

  /// Makes a Call to the LBRYD API
  ///
  /// Makes an API call for the function [method] with the given
  /// parameters [params]. The request is made to the LBRYD
  /// network, which should be running at the [url] specified as
  /// `localhost:5279`. If [timeout] is specified, then it overrides
  /// the initialized
  Future<Map> call(String method,
      {Map<String, dynamic> params = const {}, int timeout = -1}) async {
    timeout = timeout >= 0 ? this.timeout : timeout;
    return LbryBaseApi.makeRequest(url, method,
        params: params, timeout: timeout);
  }
}
