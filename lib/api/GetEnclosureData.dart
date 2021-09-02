import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';

import '../models/EnclosureStatus.dart';

Future<List<EnclosureStatus>> getEnclosureData(
    [String startTime = '162803419']) async {
  try {
    RestOptions options = RestOptions(
        path: '/enclosure/3/data', queryParameters: {'startTime': startTime});

    RestOperation restOperation = Amplify.API.get(restOptions: options);
    RestResponse response = await restOperation.response;
    print('Retrieved list of statuses!');
    print(String.fromCharCodes(response.data));
    Map<String, dynamic> responseAsJson =
        jsonDecode(String.fromCharCodes(response.data));

    List<EnclosureStatus> statusRecords = <EnclosureStatus>[];

    for (var status in responseAsJson["Items"]) {
      statusRecords.add(EnclosureStatus.fromJson(status));
    }

    return statusRecords;
  } on ApiException catch (e) {
    print('GET call failed: $e');
    throw Exception("Error");
  }
}
