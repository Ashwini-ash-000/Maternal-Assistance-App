// lib/ui/appointment_scheduling_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat

import '../models/appointment.dart'; // Import the Appointment model

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _patientNameController = TextEditingController();
  DateTime? _appointmentDate;
  TimeOfDay? _appointmentTime;
  String? _selectedHospital;
  String? _selectedDoctor;

  // Define hospitals and doctors
  Map<String, List<String>> hospitalDoctors = {
    'Hospital A': ['Dr. A1', 'Dr. A2', 'Dr. A3'],
    'Hospital B': ['Dr. B1', 'Dr. B2', 'Dr. B3', 'Dr. B4'],
    'Hospital C': ['Dr. C1', 'Dr. C2'],
    'Hospital D': ['Dr. D1', 'Dr. D2', 'Dr. D3'],
    'Hospital E': ['Dr. E1', 'Dr. E2'],
    'Hospital F': ['Dr. F1', 'Dr. F2', 'Dr. F3'],
    'Hospital G': ['Dr. G1', 'Dr. G2'],
    'Hospital H': ['Dr. H1', 'Dr. H2', 'Dr. H3'],
    'Hospital I': ['Dr. I1', 'Dr. I2'],
    'Hospital J': ['Dr. J1', 'Dr. J2', 'Dr. J3'],
  };

  List<String> hospitals = [
    'Hospital A',
    'Hospital B',
    'Hospital C',
    'Hospital D',
    'Hospital E',
    'Hospital F',
    'Hospital G',
    'Hospital H',
    'Hospital I',
    'Hospital J',
  ];

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        _appointmentDate = selectedDate;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _appointmentTime = selectedTime;
      });
    }
  }

  void _submitAppointment() {
    if (_patientNameController.text.isEmpty ||
        _appointmentDate == null ||
        _appointmentTime == null ||
        _selectedHospital == null ||
        _selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields!'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    Appointment appointment = Appointment(
      patientName: _patientNameController.text,
      doctorName: _selectedDoctor!,
      date: DateFormat('yyyy-MM-dd').format(_appointmentDate!),
      time: _appointmentTime!.format(context),
      hospitalName: _selectedHospital!,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Appointment Scheduled successfully!'),
      backgroundColor: Colors.green,
    ));

    print('Scheduled Appointment:');
    print('Patient: ${appointment.patientName}');
    print('Doctor: ${appointment.doctorName}');
    print('Date: ${appointment.date}');
    print('Time: ${appointment.time}');
    print('Hospital: ${appointment.hospitalName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/appointment.jpg'), // Your image here
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Name Input
                TextField(
                  controller: _patientNameController,
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person, color: Colors.pink),
                  ),
                ),
                SizedBox(height: 20),

                // Hospital Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedHospital,
                  hint: Text('Select Hospital'),
                  items: hospitals.map((hospital) {
                    return DropdownMenuItem(
                      value: hospital,
                      child: Text(hospital),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedHospital = value;
                      _selectedDoctor = null; // Reset doctor when hospital changes
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Hospital',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Date & Time Pickers
                Row(
                  children: [
                    // Date Picker
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          child: Text(
                            _appointmentDate != null
                                ? DateFormat('yyyy-MM-dd')
                                .format(_appointmentDate!)
                                : 'Select Date',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Time Picker
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectTime(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Time',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          child: Text(
                            _appointmentTime != null
                                ? _appointmentTime!.format(context)
                                : 'Select Time',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Doctor Dropdown (only visible when a hospital is selected)
                if (_selectedHospital != null)
                  DropdownButtonFormField<String>(
                    value: _selectedDoctor,
                    items: hospitalDoctors[_selectedHospital!]!
                        .map((doctor) {
                      return DropdownMenuItem(
                        value: doctor,
                        child: Text(doctor),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDoctor = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Doctor',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                SizedBox(height: 30),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Button color
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Schedule Appointment',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
