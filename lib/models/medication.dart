// lib/models/medication.dart
class Medication {
  final String name;
  final String dose;
  final String schedule;
  final DateTime timestamp;

  Medication({
    required this.name,
    required this.dose,
    required this.schedule,
    required this.timestamp,
  });
}
