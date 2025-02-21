// lib/ui/appointments_dashboard.dart

import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentsDashboard extends StatelessWidget {
  final List<Appointment> appointments = [
    Appointment(
      patientName: 'John Doe',
      doctorName: 'Dr. Smith',
      hospitalName: 'Hospital 1',
      date: '2025-01-15',
      time: '10:00 AM',
    ),
    Appointment(
      patientName: 'Jane Doe',
      doctorName: 'Dr. Johnson',
      hospitalName: 'Hospital 1',
      date: '2025-01-16',
      time: '2:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                '${appointment.patientName} - ${appointment.doctorName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Hospital: ${appointment.hospitalName}\nDate: ${appointment.date}, Time: ${appointment.time}',
              ),
              leading: const Icon(Icons.calendar_today),
            ),
          );
        },
      ),
    );
  }
}
