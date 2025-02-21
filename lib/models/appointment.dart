// lib/models/appointment.dart

class Appointment {
  final String patientName;
  final String doctorName;
  final String hospitalName;
  final String date;
  final String time;

  Appointment({
    required this.patientName,
    required this.doctorName,
    required this.hospitalName,
    required this.date,
    required this.time,
  });
}
