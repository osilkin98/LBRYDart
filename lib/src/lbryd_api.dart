import 'dart:async';

import 'base_api.dart';
import 'exceptions.dart';


/* This is the API file for the Lbryd API. Everything here is
* only written to be used with the Lbryd network */

class LbrydApi extends LbryBaseApi {
  final int timeout;
  static const String url = "http://localhost:5279";

  /**
   * Creates an instance of [LbrydApi]
   *
   * Creates an instance of [LbrydApi] to run on the
   * set [url], and timeout after [timeout] seconds have
   * passed since we've last made contact to the server.
   */
  LbrydApi([this.timeout = 600]);

  /**
   * Makes a Call to the LBRYD API
   *
   * Makes an API call for the function [method] with the given
   * parameters [params]. The request is made to the LBRYD
   * network, which should be running at the [url] specified as
   * `localhost:5279`. If [timeout] is specified, then it overrides
   * the instanced [self.timeout] count. If the [response] contains
   * an error from the LBRY API, then []
   */
  Future<Map> call(String method,
      {Map<String, dynamic> params = const {}, int timeout = 0}) async {
    // If the user overrides the instanced timeout
    timeout = timeout > 0 ? timeout : this.timeout;

    Map response = await LbryBaseApi.makeRequest(url, method,
        params: params, timeout: timeout);

    if (response.containsKey("error")) {
      throw (LbryException(response));
    }

    return response;
  }
}
