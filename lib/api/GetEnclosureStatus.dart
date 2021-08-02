import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';

Future<Map<String, dynamic>> getEnclosureStatus() async {
  try {
    RestOptions options =
        RestOptions(path: '/enclosure/3/status', queryParameters: {'id': '3'});

    RestOperation restOperation = Amplify.API.get(restOptions: options);
    RestResponse response = await restOperation.response;
    print('GET call succeeded');
    print(String.fromCharCodes(response.data));
    Map<String, dynamic> responseAsJson =
        jsonDecode(String.fromCharCodes(response.data));
    return responseAsJson;
  } on ApiException catch (e) {
    print('GET call failed: $e');
    throw Exception("Error");
  }
}
