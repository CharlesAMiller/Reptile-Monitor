import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';

Future<String> getVideoStream() async {
  try {
    RestOptions options = RestOptions(path: '/enclosure/3/stream');
    RestOperation restOperation = Amplify.API.get(restOptions: options);

    RestResponse response = await restOperation.response;
    print(String.fromCharCodes(response.data));
    return String.fromCharCodes(response.data).replaceAll('"', '');
  } on ApiException catch (e) {
    print('GET call failed: $e');
    throw Exception("Error");
  }
}
