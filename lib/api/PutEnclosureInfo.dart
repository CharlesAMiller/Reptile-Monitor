import 'dart:convert';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';

import '../models/EnclosureInfo.dart';

Future<void> putEnclosureInfo(EnclosureInfo info) async {
  try {
    RestOptions options = RestOptions(
        path: '/enclosure/4/',
        queryParameters: {'id': '4'},
        body: Uint8List.fromList(utf8.encode(jsonEncode(info))));

    RestOperation restOperation = Amplify.API.put(restOptions: options);
    RestResponse response = await restOperation.response;
    print('PUT call succeeded');
    print(String.fromCharCodes(response.data));
//    Map<String, dynamic> responseAsJson =
//        jsonDecode(String.fromCharCodes(response.data));
//    return EnclosureInfo.fromJson(responseAsJson["Item"]);
    return;
  } on ApiException catch (e) {
    print('PUT call failed: $e');
    throw Exception("Error");
  }
}
