import 'dart:convert';
import 'package:lbry_api/lbry.dart';


void main() async {
  
  /*  This API provides two classes, LbrydApi and LbrycrdApi.
   *  To call either simply import lbry/lbry.dart, and initialize them. 
   */
  
  // Returns an object of type LbrydApi
  var lbrydApi = LbrydApi();
  
  /* To use the API, simply provide a name to a method in the API
   * This returns the body of the HTTP Response as a JSON MAP */
  var response = await lbrydApi.call("help");

  // This prints something along the lines of:
  // id: 1, jsonrpc: 2.0, result: {about: This is the LBRY JSON-RPC API ...
  print(response);

  // Create a JSON Encoder to pretty-print output
  JsonEncoder json = JsonEncoder.withIndent('  ');

  // Now we can try and display it much more nicely
  print(json.convert(response));

  /* This prints the following:
  > {
  >   "id": 1,
  >   "jsonrpc": "2.0",
  >   "result": {
  >     "about": "This is the LBRY JSON-RPC API",
  >     "command_help": "Pass a `command` parameter to this method to see help for that command (e.g. `help command=resolve_name`)",
  >     "command_list": "Get a full list of commands using the `commands` method",
  >     "more_info": "Visit https://lbry.io/api for more info"
  >   }
  > }

  As we can see, the actual body of the response is given in the `result`
  field, however the everything in the response is returned for
  better context about what specific request did what.
 */

  // To access the Map, use simple Map notation
  print(response["result"]["about"]);

  // To get the ID of the last request, simply use the LbryApi's getter.
  int id = lbrydApi.requestId;


  /* If we want to use parameters to functions, we can do so as follows: */
  var metatableDict = await lbrydApi.call("resolve_name",
      params: {
        "name": "doge",
        "force": true,
      });
  
  print(json.convert(metatableDict));

    /* Since the HTTP Methods are asynchronous, the method
   * returns a dynamic Map representing the JSON dict returned
   * by the API.
   *
   * It is preferable to use the await keyword instead of
   * using the Futures API, however you may do as you please.
   * */


  /* We can also use the Future API */
  lbrydApi.call("resolve",
      params: {
    "uri": "doge",
    "uris": ["crab", "otter", "turtle"]
  }).then((response) {
    print(json.convert(response));
  });

  /*
    LbrycrdApi works in the same way as LbrydApi, however
    LbrycrdApi requires your username and password when
    initializing the object to use the API  */
  var lbrycrdApi = LbrycrdApi("username", "password");

  /* Since lbrynet isn't running currently, this will error out.
  *  This is the (uglier) way to asynchronously handle errors
  *  and responses through the Future API */
  lbrycrdApi.call("help").then((response) {
    print(json.convert(response));
  }).catchError((error) {
    print(error);
  });

}