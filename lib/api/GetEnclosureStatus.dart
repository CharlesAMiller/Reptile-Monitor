import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';

import '../models/EnclosureStatus.dart';

Future<EnclosureStatus> getEnclosureStatus() async {
  try {
    RestOptions options =
        RestOptions(path: '/enclosure/3/status', queryParameters: {'id': '3'});

    RestOperation restOperation = Amplify.API.get(restOptions: options);
    RestResponse response = await restOperation.response;
    print('GET call succeeded');
    print(String.fromCharCodes(response.data));
    Map<String, dynamic> responseAsJson =
        jsonDecode(String.fromCharCodes(response.data));
    return EnclosureStatus.fromJson(responseAsJson["Item"]);
  } on ApiException catch (e) {
    print('GET call failed: $e');
    throw Exception("Error");
  }
}
