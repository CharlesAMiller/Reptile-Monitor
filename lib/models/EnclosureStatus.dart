// Representation of an enclosure's temperature/living conditions.
//
//

import 'SensorValue.dart';

class EnclosureStatus {
  final String CreatedAt;
  final String EnclosureId;
  final List<SensorValue> sensors;

  EnclosureStatus(
      {required this.CreatedAt,
      required this.EnclosureId,
      required this.sensors});

  factory EnclosureStatus.fromJson(Map<String, dynamic> json) {
    List<dynamic> sensors = json["data"]["sensors"];
    List<SensorValue> sensorValues = <SensorValue>[];
    sensors.forEach((element) {
      sensorValues.add(SensorValue.fromJson(element));
    });

    return EnclosureStatus(
        CreatedAt: json["CreatedAt"],
        EnclosureId: json["EnclosureId"],
        sensors: sensorValues);
  }
}
