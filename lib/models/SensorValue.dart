// Representation of an enclosure's temperature/living conditions.
//
//
class SensorValue {
  final double value;
  final String type;
  final int sensor_id;

  SensorValue(
      {required this.value, required this.type, required this.sensor_id});

  factory SensorValue.fromJson(Map<String, dynamic> json) {
    return SensorValue(
        sensor_id: json['sensor_id'], type: json['type'], value: json['value']);
  }
}
