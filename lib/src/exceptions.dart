class LbryException implements Exception {
  final int statusCode, requestId;
  final String message;
  final Map response;
  final List data;

  /** Creates a LBRYException object
   *
   * Given the Map [response] from the Lbrynet server response,
   * the [statusCode] int, [message] String, and [data] List are
   * all obtained from the `error` field in [response].
   */
  LbryException(this.response)
      : requestId = response["id"],
        statusCode = response["error"].containsKey("code")
            ? response["error"]["code"]
            : 0,
        message = response["error"].containsKey("message")
            ? response["error"]["message"]
            : "",
        data = response["error"].containsKey("data")
            ? response["error"]["data"]
            : const [];

  String toString() =>
      "Request ID #$requestId got Error: " +
      "$message, (Status Code: ${statusCode})";

  Map error() => response["error"];
}
