// Representation of an enclosure's temperature/living conditions.
//
//
class SensorLimit {
  final double min;
  final double max;
  final int sensor_id;
  final String type;

  const SensorLimit(
      {required this.sensor_id,
      required this.type,
      required this.min,
      required this.max});

  factory SensorLimit.fromJson(Map<String, dynamic> json) {
    return SensorLimit(
        sensor_id: json['sensor_id'],
        type: json['type'],
        min: json['min'],
        max: json['max']);
  }
}
