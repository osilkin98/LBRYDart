

class LbryException implements Exception {

  final num statusCode;
  final String message;
  final Map response;

  LbryException(this.response) :
        statusCode = response["error"]["code"],
        message = response["error"]["message"];

}