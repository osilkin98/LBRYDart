

class LBRYException implements Exception {

  final num statusCode;
  final String message;
  final Map response;

  LBRYException(this.response) :
        statusCode = response["error"]["code"],
        message = response["error"]["message"];

}