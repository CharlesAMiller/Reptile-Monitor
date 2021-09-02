// Representation of an enclosure's temperature/living conditions.
//
//

import 'SensorLimit.dart';

class EnclosureInfo {
  final String id;
  final List<SensorLimit> sensorLimits;

  EnclosureInfo({required this.id, required this.sensorLimits});

  factory EnclosureInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> sensors = json["sensors"];
    List<SensorLimit> sensorLimits = <SensorLimit>[];
    sensors.forEach((key, value) {
      sensorLimits.add(SensorLimit.fromJson(value));
    });
    return EnclosureInfo(id: json["id"], sensorLimits: sensorLimits);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sensors': {
          "0": sensorLimits[0].toJson(),
          "1": sensorLimits[1].toJson()
        },
      };
}
