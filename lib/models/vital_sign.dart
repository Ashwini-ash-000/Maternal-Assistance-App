class VitalSign {
  final double bloodPressure;
  final double heartRate;
  final double temperature;
  final double weight;
  final DateTime timestamp;

  VitalSign({
    required this.bloodPressure,
    required this.heartRate,
    required this.temperature,
    required this.weight,
    required this.timestamp,
  });

  // Convert a VitalSign object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'temperature': temperature,
      'weight': weight,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to string
    };
  }

  // Create a VitalSign object from a JSON map
  factory VitalSign.fromJson(Map<String, dynamic> json) {
    return VitalSign(
      bloodPressure: json['bloodPressure'],
      heartRate: json['heartRate'],
      temperature: json['temperature'],
      weight: json['weight'],
      timestamp: DateTime.parse(json['timestamp']), // Convert string to DateTime
    );
  }
}
