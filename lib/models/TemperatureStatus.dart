// Representation of an enclosure's temperature/living conditions.
//
//
class TemperatureStatus {
  final double temperature;
  final double humidity;
  final DateTime timestamp;

  TemperatureStatus(
      {required this.temperature,
      required this.humidity,
      required this.timestamp});

  factory TemperatureStatus.fromJson(Map<String, dynamic> json) {
    return TemperatureStatus(
        temperature: json['temperature'],
        humidity: json['humidity'],
        timestamp: json['timestamp']);
  }
}
