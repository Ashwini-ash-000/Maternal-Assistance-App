// // lib/ui/appointment_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/appointment.dart'; // Import the Appointment model

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/appointment.dart'; // Import the Appointment model
import 'package:timezone/data/latest.dart' as tz; // Import timezone library
import 'package:timezone/timezone.dart' as tz;

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

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize time zones
    _initializeNotifications();
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidInitializationSettings);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(DateTime dateTime, String title, String body, int id) async {
    final location = tz.getLocation('Asia/Kolkata'); // Use correct time zone (India Standard Time)
    final tzDateTime = tz.TZDateTime.from(dateTime, location); // Convert DateTime to TZDateTime

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'appointment_channel',
      'Appointment Notifications',
      channelDescription: 'Notifications for upcoming appointments',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // icon: 'app_icon', // Specify the app icon
      // largeIcon: DrawableResourceAndroidBitmap('assets/images/logo.png'), // Specify the logo image
    );

    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime, // Use TZDateTime here
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _scheduleAppointmentNotifications(DateTime appointmentDateTime) {
    final now = DateTime.now();
    if (appointmentDateTime.isAfter(now)) {
      final twoHoursBefore = appointmentDateTime.subtract(Duration(hours: 2));
      final oneHourBefore = appointmentDateTime.subtract(Duration(hours: 1));
      final thirtyMinutesBefore = appointmentDateTime.subtract(Duration(minutes: 30));

      if (twoHoursBefore.isAfter(now)) {
        _scheduleNotification(
          twoHoursBefore,
          '⏰ appointment is in 2 hours! ⏰',
          'Time to put your feet up and let the baby and you be pampered!👣💆‍♀️👶💖',
          1,
        );
      }

      if (oneHourBefore.isAfter(now)) {
        _scheduleNotification(
          oneHourBefore,
          '⏰appointment is in 1 hour!⏰',
          'Don\'t forget to smile, you are glowing!👶💅✨',
          2,
        );
      }

      if (thirtyMinutesBefore.isAfter(now)) {
        _scheduleNotification(
          thirtyMinutesBefore,
          '⏰appointment is in 30 minutes!⏰',
          'Let\'s get ready for some pampering, mama!💆‍♀️👶💖',
          3,
        );
      }
    }
  }

  // Define hospitals and doctors
  final Map<String, List<String>> _hospitalDoctors = {
    'Cloudnine Hospital': [
      'Dr. Aarti Kapoor, MD',
      'Dr. Priya Sharma, MBBS',
      'Dr. Kavita Yadav, DGO'
    ],
    'Apollo & Children Hospital': [
      'Dr. Sita Reddy, MD',
      'Dr. Rekha Nair, MBBS'
    ],
    'Fortis La Femme': [
      'Dr. Neelam Verma, MD',
      'Dr. Ranjana Kapoor, DGO'
    ],
    'Rainbow Children Hospital': [
      'Dr. Shalini Desai, MBBS',
      'Dr. Nisha Singh, MBBS'
    ],
    'Manipal Maternity Wing': [
      'Dr. Meera Iyer, MD',
      'Dr. Maya Patel, MD',
      'Dr. Sunita Mehta, DGO'
    ],
    'Max Super Speciality': [
      'Dr. Ashwini, MD'
    ],
    'Motherhood Hospital': [
      'Dr. Anita Singh, MBBS',
      'Dr. Kanika Bhardwaj, DGO'
    ],
    'Jehangir Hospital': [
      'Dr. Radhika Rani, MD',
      'Dr. Meenakshi Kumar, MBBS'
    ],
    'Columbia Asia Hospital': [
      'Dr. Aishwarya Rao, MD',
      'Dr. Farida Jahan, DGO'
    ],
    'Holy Family Hospital': [
      'Dr. Shubha Patil, MBBS',
      'Dr. Pratima Joshi, MD'
    ],
  };

  final List<String> _hospitals = [
    'Cloudnine Hospital',
    'Apollo & Children Hospital',
    'Fortis La Femme',
    'Rainbow Children Hospital',
    'Manipal Maternity Wing',
    'Max Super Speciality',
    'Motherhood Hospital',
    'Jehangir Hospital',
    'Columbia Asia Hospital',
    'Holy Family Hospital'
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

    DateTime appointmentDateTime = DateTime(
      _appointmentDate!.year,
      _appointmentDate!.month,
      _appointmentDate!.day,
      _appointmentTime!.hour,
      _appointmentTime!.minute,
    );

    Appointment appointment = Appointment(
      patientName: _patientNameController.text,
      doctorName: _selectedDoctor!,
      date: DateFormat('yyyy-MM-dd').format(_appointmentDate!),
      time: _appointmentTime!.format(context),
      hospitalName: _selectedHospital!,
    );

    _scheduleAppointmentNotifications(appointmentDateTime);

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
    List<String> doctors = _selectedHospital != null
        ? _hospitalDoctors[_selectedHospital!] ?? []
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment'),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                items: _hospitals.map((hospital) {
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
                              ? DateFormat('yyyy-MM-dd').format(_appointmentDate!)
                              : 'Select Date',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Doctor Dropdown
              if (_selectedHospital != null)
                DropdownButtonFormField<String>(
                  value: _selectedDoctor,
                  hint: Text('Select Doctor'),
                  items: doctors.map((doctor) {
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
                    labelText: 'Doctor',
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
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For DateFormat
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import '../main.dart'; // For accessing `flutterLocalNotificationsPlugin`
//
// class AppointmentPage extends StatefulWidget {
//   @override
//   _AppointmentPageState createState() => _AppointmentPageState();
// }
//
// class _AppointmentPageState extends State<AppointmentPage> {
//   final _patientNameController = TextEditingController();
//   DateTime? _appointmentDate;
//   TimeOfDay? _appointmentTime;
//   String? _selectedHospital;
//   String? _selectedDoctor;
//
//   // Define hospitals and doctors
//   final Map<String, List<String>> hospitalDoctors = {
//     'Cloudnine Hospital': ['Dr. Aarti Kapoor, MD', 'Dr. Priya Sharma, MBBS'],
//     'Apollo & Children Hospital': ['Dr. Sita Reddy, MD', 'Dr. Rekha Nair, MBBS'],
//   };
//
//   final List<String> hospitals = [
//     'Cloudnine Hospital',
//     'Apollo & Children Hospital',
//   ];
//
//   void _selectDate(BuildContext context) async {
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null) {
//       setState(() {
//         _appointmentDate = selectedDate;
//       });
//     }
//   }
//
//   void _selectTime(BuildContext context) async {
//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (selectedTime != null) {
//       setState(() {
//         _appointmentTime = selectedTime;
//       });
//     }
//   }
//
//   Future<void> _scheduleNotifications(DateTime appointmentDateTime) async {
//     final reminders = [
//       appointmentDateTime.subtract(Duration(hours: 2)), // 2 hours before
//       appointmentDateTime.subtract(Duration(hours: 1)), // 1 hour before
//       appointmentDateTime.subtract(Duration(minutes: 30)), // 30 minutes before
//     ];
//
//     for (int i = 0; i < reminders.length; i++) {
//       if (reminders[i].isAfter(DateTime.now())) {
//         await flutterLocalNotificationsPlugin.zonedSchedule(
//           i,
//           'Appointment Reminder',
//           'Your appointment is coming up at ${DateFormat('hh:mm a').format(appointmentDateTime)}!',
//           tz.TZDateTime.from(reminders[i], tz.local),
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'appointment_reminders',
//               'Appointment Reminders',
//               importance: Importance.high,
//               priority: Priority.high,
//             ),
//           ),
//           androidAllowWhileIdle: true,
//           uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//         );
//       }
//     }
//   }
//
//   void _submitAppointment() async {
//     if (_patientNameController.text.isEmpty ||
//         _appointmentDate == null ||
//         _appointmentTime == null ||
//         _selectedHospital == null ||
//         _selectedDoctor == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please fill all fields!'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     final appointmentDateTime = DateTime(
//       _appointmentDate!.year,
//       _appointmentDate!.month,
//       _appointmentDate!.day,
//       _appointmentTime!.hour,
//       _appointmentTime!.minute,
//     );
//
//     await _scheduleNotifications(appointmentDateTime);
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Appointment Scheduled and Reminders Set!'),
//       backgroundColor: Colors.green,
//     ));
//
//     // Clear form fields after submission
//     _patientNameController.clear();
//     setState(() {
//       _appointmentDate = null;
//       _appointmentTime = null;
//       _selectedHospital = null;
//       _selectedDoctor = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Schedule Appointment'),
//         backgroundColor: Colors.pink,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _patientNameController,
//               decoration: InputDecoration(
//                 labelText: 'Patient Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             DropdownButtonFormField<String>(
//               value: _selectedHospital,
//               hint: Text('Select Hospital'),
//               items: hospitals.map((hospital) {
//                 return DropdownMenuItem(
//                   value: hospital,
//                   child: Text(hospital),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedHospital = value;
//                   _selectedDoctor = null; // Reset doctor selection
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             if (_selectedHospital != null)
//               DropdownButtonFormField<String>(
//                 value: _selectedDoctor,
//                 hint: Text('Select Doctor'),
//                 items: hospitalDoctors[_selectedHospital!]!.map((doctor) {
//                   return DropdownMenuItem(
//                     value: doctor,
//                     child: Text(doctor),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedDoctor = value;
//                   });
//                 },
//               ),
//             SizedBox(height: 20),
//             GestureDetector(
//               onTap: () => _selectDate(context),
//               child: InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Select Date',
//                   border: OutlineInputBorder(),
//                 ),
//                 child: Text(
//                   _appointmentDate != null
//                       ? DateFormat('yyyy-MM-dd').format(_appointmentDate!)
//                       : 'Choose Date',
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             GestureDetector(
//               onTap: () => _selectTime(context),
//               child: InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Select Time',
//                   border: OutlineInputBorder(),
//                 ),
//                 child: Text(
//                   _appointmentTime != null
//                       ? _appointmentTime!.format(context)
//                       : 'Choose Time',
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _submitAppointment,
//               child: Text('Schedule Appointment'),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For DateFormat
// import '../models/appointment.dart'; // Import the Appointment model
//
// class AppointmentPage extends StatefulWidget {
//   @override
//   _AppointmentPageState createState() => _AppointmentPageState();
// }
//
// class _AppointmentPageState extends State<AppointmentPage> {
//   final _patientNameController = TextEditingController();
//   DateTime? _appointmentDate;
//   TimeOfDay? _appointmentTime;
//   String? _selectedHospital;
//   String? _selectedDoctor;
//
//   // Define hospitals and doctors
//   final Map<String, List<String>> _hospitalDoctors = {
//     'Cloudnine Hospital': [
//       'Dr. Aarti Kapoor, MD',
//       'Dr. Priya Sharma, MBBS',
//       'Dr. Kavita Yadav, DGO'
//     ],
//     'Apollo & Children Hospital': [
//       'Dr. Sita Reddy, MD',
//       'Dr. Rekha Nair, MBBS'
//     ],
//     'Fortis La Femme': [
//       'Dr. Neelam Verma, MD',
//       'Dr. Ranjana Kapoor, DGO'
//     ],
//     'Rainbow Children Hospital': [
//       'Dr. Shalini Desai, MBBS',
//       'Dr. Nisha Singh, MBBS'
//     ],
//     'Manipal Maternity Wing': [
//       'Dr. Meera Iyer, MD',
//       'Dr. Maya Patel, MD',
//       'Dr. Sunita Mehta, DGO'
//     ],
//     'Max Super Speciality': [
//       'Dr. Ashwini, MD'
//     ],
//     'Motherhood Hospital': [
//       'Dr. Anita Singh, MBBS',
//       'Dr. Kanika Bhardwaj, DGO'
//     ],
//     'Jehangir Hospital': [
//       'Dr. Radhika Rani, MD',
//       'Dr. Meenakshi Kumar, MBBS'
//     ],
//     'Columbia Asia Hospital': [
//       'Dr. Aishwarya Rao, MD',
//       'Dr. Farida Jahan, DGO'
//     ],
//     'Holy Family Hospital': [
//       'Dr. Shubha Patil, MBBS',
//       'Dr. Pratima Joshi, MD'
//     ],
//   };
//
//   final List<String> _hospitals = [
//     'Cloudnine Hospital',
//     'Apollo & Children Hospital',
//     'Fortis La Femme',
//     'Rainbow Children Hospital',
//     'Manipal Maternity Wing',
//     'Max Super Speciality',
//     'Motherhood Hospital',
//     'Jehangir Hospital',
//     'Columbia Asia Hospital',
//     'Holy Family Hospital'
//   ];
//
//   void _selectDate(BuildContext context) async {
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2101),
//     );
//     if (selectedDate != null) {
//       setState(() {
//         _appointmentDate = selectedDate;
//       });
//     }
//   }
//
//   void _selectTime(BuildContext context) async {
//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (selectedTime != null) {
//       setState(() {
//         _appointmentTime = selectedTime;
//       });
//     }
//   }
//
//   void _submitAppointment() {
//     if (_patientNameController.text.isEmpty ||
//         _appointmentDate == null ||
//         _appointmentTime == null ||
//         _selectedHospital == null ||
//         _selectedDoctor == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please fill all fields!'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     Appointment appointment = Appointment(
//       patientName: _patientNameController.text,
//       doctorName: _selectedDoctor!,
//       date: DateFormat('yyyy-MM-dd').format(_appointmentDate!),
//       time: _appointmentTime!.format(context),
//       hospitalName: _selectedHospital!,
//     );
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Appointment Scheduled successfully!'),
//       backgroundColor: Colors.green,
//     ));
//
//     print('Scheduled Appointment:');
//     print('Patient: ${appointment.patientName}');
//     print('Doctor: ${appointment.doctorName}');
//     print('Date: ${appointment.date}');
//     print('Time: ${appointment.time}');
//     print('Hospital: ${appointment.hospitalName}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> doctors = _selectedHospital != null
//         ? _hospitalDoctors[_selectedHospital!] ?? []
//         : [];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Schedule Appointment'),
//         backgroundColor: Colors.pink,
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Patient Name Input
//               TextField(
//                 controller: _patientNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Patient Name',
//                   border: OutlineInputBorder(),
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: Icon(Icons.person, color: Colors.pink),
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Hospital Dropdown
//               DropdownButtonFormField<String>(
//                 value: _selectedHospital,
//                 hint: Text('Select Hospital'),
//                 items: _hospitals.map((hospital) {
//                   return DropdownMenuItem(
//                     value: hospital,
//                     child: Text(hospital),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedHospital = value;
//                     _selectedDoctor = null; // Reset doctor when hospital changes
//                   });
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Hospital',
//                   border: OutlineInputBorder(),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 20),
//
//               // Date & Time Pickers
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _selectDate(context),
//                       child: InputDecorator(
//                         decoration: InputDecoration(
//                           labelText: 'Date',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         child: Text(
//                           _appointmentDate != null
//                               ? DateFormat('yyyy-MM-dd').format(_appointmentDate!)
//                               : 'Select Date',
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => _selectTime(context),
//                       child: InputDecorator(
//                         decoration: InputDecoration(
//                           labelText: 'Time',
//                           border: OutlineInputBorder(),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         child: Text(
//                           _appointmentTime != null
//                               ? _appointmentTime!.format(context)
//                               : 'Select Time',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//
//               // Doctor Dropdown
//               if (_selectedHospital != null)
//                 DropdownButtonFormField<String>(
//                   value: _selectedDoctor,
//                   hint: Text('Select Doctor'),
//                   items: doctors.map((doctor) {
//                     return DropdownMenuItem(
//                       value: doctor,
//                       child: Text(doctor),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedDoctor = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Doctor',
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               SizedBox(height: 30),
//
//               // Submit Button
//               ElevatedButton(
//                 onPressed: _submitAppointment,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   'Schedule Appointment',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart'; // For DateFormat
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import '../main.dart'; // For accessing `flutterLocalNotificationsPlugin`
// //
// //
// // import '../models/appointment.dart'; // Import the Appointment model
// //
// // class AppointmentPage extends StatefulWidget {
// //   @override
// //   _AppointmentPageState createState() => _AppointmentPageState();
// // }
// //
// // class _AppointmentPageState extends State<AppointmentPage> {
// //   final _patientNameController = TextEditingController();
// //   DateTime? _appointmentDate;
// //   TimeOfDay? _appointmentTime;
// //   String? _selectedHospital;
// //   String? _selectedDoctor;
// //
// //   // Define hospitals and doctors
// //   final Map<String, List<String>> hospitalDoctors  = {
// //     'Cloudnine Hospital': [
// //       'Dr. Aarti Kapoor, MD',
// //       'Dr. Priya Sharma, MBBS',
// //       'Dr. Kavita Yadav, DGO'
// //     ],
// //     'Apollo & Children Hospital': [
// //       'Dr. Sita Reddy, MD',
// //       'Dr. Rekha Nair, MBBS'
// //     ],
// //     'Fortis La Femme': [
// //       'Dr. Neelam Verma, MD',
// //       'Dr. Ranjana Kapoor, DGO'
// //     ],
// //     'Rainbow Children Hospital': [
// //       'Dr. Shalini Desai, MBBS',
// //       'Dr. Nisha Singh, MBBS'
// //     ],
// //     'Manipal Maternity Wing': [
// //       'Dr. Meera Iyer, MD',
// //       'Dr. Maya Patel, MD',
// //       'Dr. Sunita Mehta, DGO'
// //     ],
// //     'Max Super Speciality': [
// //       'Dr. Ashwini, MD'
// //     ],
// //     'Motherhood Hospital': [
// //       'Dr. Anita Singh, MBBS',
// //       'Dr. Kanika Bhardwaj, DGO'
// //     ],
// //     'Jehangir Hospital': [
// //       'Dr. Radhika Rani, MD',
// //       'Dr. Meenakshi Kumar, MBBS'
// //     ],
// //     'Columbia Asia Hospital': [
// //       'Dr. Aishwarya Rao, MD',
// //       'Dr. Farida Jahan, DGO'
// //     ],
// //     'Holy Family Hospital': [
// //       'Dr. Shubha Patil, MBBS',
// //       'Dr. Pratima Joshi, MD'
// //     ],
// //   };
// //
// //
// //   List<String> hospitals = [
// //     'Cloudnine Hospital',
// //     'Apollo & Children Hospital',
// //     'Fortis La Femme',
// //     'Rainbow Children Hospital',
// //     'Manipal Maternity Wing',
// //     'Max Super Speciality',
// //     'Motherhood Hospital',
// //     'Jehangir Hospital',
// //     'Columbia Asia Hospital',
// //     'Holy Family Hospital'
// //   ];
// //
// //   void _selectDate(BuildContext context) async {
// //     final selectedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2023),
// //       lastDate: DateTime(2101),
// //     );
// //     if (selectedDate != null) {
// //       setState(() {
// //         _appointmentDate = selectedDate;
// //       });
// //     }
// //   }
// //
// //   void _selectTime(BuildContext context) async {
// //     final selectedTime = await showTimePicker(
// //       context: context,
// //       initialTime: TimeOfDay.now(),
// //     );
// //     if (selectedTime != null) {
// //       setState(() {
// //         _appointmentTime = selectedTime;
// //       });
// //     }
// //   }
// //
// //   void _submitAppointment() {
// //     if (_patientNameController.text.isEmpty ||
// //         _appointmentDate == null ||
// //         _appointmentTime == null ||
// //         _selectedHospital == null ||
// //         _selectedDoctor == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text('Please fill all fields!'),
// //         backgroundColor: Colors.red,
// //       ));
// //       return;
// //     }
// //
// //     Appointment appointment = Appointment(
// //       patientName: _patientNameController.text,
// //       doctorName: _selectedDoctor!,
// //       date: DateFormat('yyyy-MM-dd').format(_appointmentDate!),
// //       time: _appointmentTime!.format(context),
// //       hospitalName: _selectedHospital!,
// //     );
// //
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //       content: Text('Appointment Scheduled successfully!'),
// //       backgroundColor: Colors.green,
// //     ));
// //
// //     print('Scheduled Appointment:');
// //     print('Patient: ${appointment.patientName}');
// //     print('Doctor: ${appointment.doctorName}');
// //     print('Date: ${appointment.date}');
// //     print('Time: ${appointment.time}');
// //     print('Hospital: ${appointment.hospitalName}');
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Schedule Appointment'),
// //         backgroundColor: Colors.pink,
// //       ),
// //       backgroundColor: Colors.white,
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Patient Name Input
// //               TextField(
// //                 controller: _patientNameController,
// //                 decoration: InputDecoration(
// //                   labelText: 'Patient Name',
// //                   border: OutlineInputBorder(),
// //                   filled: true,
// //                   fillColor: Colors.white,
// //                   prefixIcon: Icon(Icons.person, color: Colors.pink),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //
// //               // Hospital Dropdown
// //               DropdownButtonFormField<String>(
// //                 value: _selectedHospital,
// //                 hint: Text('Select Hospital'),
// //                 items: hospitals.map((hospital) {
// //                   return DropdownMenuItem(
// //                     value: hospital,
// //                     child: Text(hospital),
// //                   );
// //                 }).toList(),
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _selectedHospital = value;
// //                     _selectedDoctor = null; // Reset doctor when hospital changes
// //                   });
// //                 },
// //                 decoration: InputDecoration(
// //                   labelText: 'Hospital',
// //                   border: OutlineInputBorder(),
// //                   filled: true,
// //                   fillColor: Colors.white,
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //
// //               // Date & Time Pickers (Responsive Layout)
// //               LayoutBuilder(
// //                 builder: (context, constraints) {
// //                   return Wrap(
// //                     spacing: 10.0, // Space between elements
// //                     runSpacing: 10.0, // Space between lines
// //                     children: [
// //                       // Date Picker
// //                       SizedBox(
// //                         width: constraints.maxWidth * 0.45, // Responsive width
// //                         child: GestureDetector(
// //                           onTap: () => _selectDate(context),
// //                           child: InputDecorator(
// //                             decoration: InputDecoration(
// //                               labelText: 'Date',
// //                               border: OutlineInputBorder(),
// //                               filled: true,
// //                               fillColor: Colors.white,
// //                             ),
// //                             child: Text(
// //                               _appointmentDate != null
// //                                   ? DateFormat('yyyy-MM-dd')
// //                                   .format(_appointmentDate!)
// //                                   : 'Select Date',
// //                               style: TextStyle(color: Colors.black),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       // Time Picker
// //                       SizedBox(
// //                         width: constraints.maxWidth * 0.45, // Responsive width
// //                         child: GestureDetector(
// //                           onTap: () => _selectTime(context),
// //                           child: InputDecorator(
// //                             decoration: InputDecoration(
// //                               labelText: 'Time',
// //                               border: OutlineInputBorder(),
// //                               filled: true,
// //                               fillColor: Colors.white,
// //                             ),
// //                             child: Text(
// //                               _appointmentTime != null
// //                                   ? _appointmentTime!.format(context)
// //                                   : 'Select Time',
// //                               style: TextStyle(color: Colors.black),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   );
// //                 },
// //               ),
// //               SizedBox(height: 20),
// //
// //               // Doctor Dropdown (only visible when a hospital is selected)
// //               if (_selectedHospital != null)
// //                 DropdownButtonFormField<String>(
// //                   value: _selectedDoctor,
// //                   items: hospitalDoctors[_selectedHospital!]!
// //                       .map((doctor) {
// //                     return DropdownMenuItem(
// //                       value: doctor,
// //                       child: Text(doctor),
// //                     );
// //                   }).toList(),
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _selectedDoctor = value;
// //                     });
// //                   },
// //                   decoration: InputDecoration(
// //                     labelText: 'Select Doctor',
// //                     border: OutlineInputBorder(),
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                   ),
// //                 ),
// //               SizedBox(height: 30),
// //
// //               // Submit Button
// //               ElevatedButton(
// //                 onPressed: _submitAppointment,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.pink, // Button color
// //                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 child: Text(
// //                   'Schedule Appointment',
// //                   style: TextStyle(fontSize: 18),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//
//
//
// // import 'package:flutter/material.dart';
// //
// // class AppointmentPage extends StatefulWidget {
// //   @override
// //   _AppointmentPageState createState() => _AppointmentPageState();
// // }
// //
// // class _AppointmentPageState extends State<AppointmentPage> {
// //   final TextEditingController patientNameController = TextEditingController();
// //   String? selectedHospital;
// //   String? selectedDoctor;
// //   DateTime selectedDate = DateTime.now();
// //   TimeOfDay selectedTime = TimeOfDay.now();
// //
// //   final Map<String, List<String>> hospitals = {
// //     'Cloudnine Hospital': [
// //       'Dr. Aarti Kapoor, MD',
// //       'Dr. Priya Sharma, MBBS',
// //       'Dr. Kavita Yadav, DGO'
// //     ],
// //     'Apollo & Children Hospital': [
// //       'Dr. Sita Reddy, MD',
// //       'Dr. Rekha Nair, MBBS'
// //     ],
// //     'Fortis La Femme': [
// //       'Dr. Neelam Verma, MD',
// //       'Dr. Ranjana Kapoor, DGO'
// //     ],
// //     'Rainbow Children Hospital': [
// //       'Dr. Shalini Desai, MBBS',
// //       'Dr. Nisha Singh, MBBS'
// //     ],
// //     'Maternity Wing': [
// //       'Dr. Meera Iyer, MD',
// //       'Dr. Maya Patel, MD',
// //       'Dr. Sunita Mehta, DGO'
// //     ],
// //     'Max Super Speciality': [
// //       'Dr. Ashwini, MD'
// //     ],
// //     'Motherhood Hospital': [
// //       'Dr. Anita Singh, MBBS',
// //       'Dr. Kanika Bhardwaj, DGO'
// //     ],
// //     'Jehangir Hospital': [
// //       'Dr. Radhika Rani, MD',
// //       'Dr. Meenakshi Kumar, MBBS'
// //     ],
// //     'Columbia Asia Hospital': [
// //       'Dr. Aishwarya Rao, MD',
// //       'Dr. Farida Jahan, DGO'
// //     ],
// //     'Holy Family Hospital': [
// //       'Dr. Shubha Patil, MBBS',
// //       'Dr. Pratima Joshi, MD'
// //     ],
// //   };
// //
// //   void _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //     if (picked != null && picked != selectedDate)
// //       setState(() {
// //         selectedDate = picked;
// //       });
// //   }
// //
// //   void _selectTime(BuildContext context) async {
// //     final TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: selectedTime,
// //     );
// //     if (picked != null && picked != selectedTime)
// //       setState(() {
// //         selectedTime = picked;
// //       });
// //   }
// //
// //   void _bookAppointment() {
// //     if (patientNameController.text.isEmpty || selectedHospital == null || selectedDoctor == null) {
// //       // Show an error message if required fields are not filled
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')));
// //       return;
// //     }
// //     // Booking logic here (save to database, etc.)
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Appointment Booked'),
// //         content: Text(
// //           'Patient Name: ${patientNameController.text}\n'
// //               'Hospital: $selectedHospital\n'
// //               'Doctor: $selectedDoctor\n'
// //               'Date: ${selectedDate.toLocal()}\n'
// //               'Time: ${selectedTime.format(context)}',
// //         ),
// //         actions: [
// //           TextButton(
// //             child: Text('OK'),
// //             onPressed: () => Navigator.pop(context),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Book Appointment')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: ListView(
// //           children: [
// //             TextField(
// //               controller: patientNameController,
// //               decoration: InputDecoration(
// //                 labelText: 'Patient Name',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             DropdownButtonFormField<String>(
// //               value: selectedHospital,
// //               decoration: InputDecoration(
// //                 labelText: 'Select Hospital',
// //                 border: OutlineInputBorder(),
// //               ),
// //               items: hospitals.keys.map((String hospital) {
// //                 return DropdownMenuItem<String>(
// //                   value: hospital,
// //                   child: Text(hospital),
// //                 );
// //               }).toList(),
// //               onChanged: (String? newValue) {
// //                 setState(() {
// //                   selectedHospital = newValue;
// //                   selectedDoctor = null;  // Reset doctor selection
// //                 });
// //               },
// //             ),
// //             SizedBox(height: 16),
// //             if (selectedHospital != null)
// //               DropdownButtonFormField<String>(
// //                 value: selectedDoctor,
// //                 decoration: InputDecoration(
// //                   labelText: 'Select Doctor',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 items: hospitals[selectedHospital]!.map((String doctor) {
// //                   return DropdownMenuItem<String>(
// //                     value: doctor,
// //                     child: Text(doctor),
// //                   );
// //                 }).toList(),
// //                 onChanged: (String? newValue) {
// //                   setState(() {
// //                     selectedDoctor = newValue;
// //                   });
// //                 },
// //               ),
// //             SizedBox(height: 16),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: InkWell(
// //                     onTap: () => _selectDate(context),
// //                     child: InputDecorator(
// //                       decoration: InputDecoration(
// //                         labelText: 'Select Date',
// //                         border: OutlineInputBorder(),
// //                       ),
// //                       child: Text('${selectedDate.toLocal()}'.split(' ')[0]),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 16),
// //                 Expanded(
// //                   child: InkWell(
// //                     onTap: () => _selectTime(context),
// //                     child: InputDecorator(
// //                       decoration: InputDecoration(
// //                         labelText: 'Select Time',
// //                         border: OutlineInputBorder(),
// //                       ),
// //                       child: Text(selectedTime.format(context)),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 24),
// //             ElevatedButton(
// //               onPressed: _bookAppointment,
// //               child: Text('Book Appointment'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:intl/intl.dart'; // For DateFormat
// // //
// // // import '../models/appointment.dart'; // Import the Appointment model
// // //
// // // class AppointmentPage extends StatefulWidget {
// // //   @override
// // //   _AppointmentPageState createState() => _AppointmentPageState();
// // // }
// // //
// // // class _AppointmentPageState extends State<AppointmentPage> {
// // //   final _patientNameController = TextEditingController();
// // //   DateTime? _appointmentDate;
// // //   TimeOfDay? _appointmentTime;
// // //   String _selectedHospital = 'Cloudnine Hospital'; // Default hospital
// // //   String? _selectedDoctor;
// // //
// // //   // List of hospitals with doctors
// // //   final Map<String, List<String>> hospitals = {
// // //     'Cloudnine Hospital': [
// // //       'Dr. Aarti Kapoor, MD',
// // //       'Dr. Priya Sharma, MBBS',
// // //       'Dr. Kavita Yadav, DGO'
// // //     ],
// // //     'Apollo & Children Hospital': [
// // //       'Dr. Sita Reddy, MD',
// // //       'Dr. Rekha Nair, MBBS'
// // //     ],
// // //     'Fortis La Femme': [
// // //       'Dr. Neelam Verma, MD',
// // //       'Dr. Ranjana Kapoor, DGO'
// // //     ]
// // //   };
// // //
// // //   void _selectDate(BuildContext context) async {
// // //     final selectedDate = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime(2023),
// // //       lastDate: DateTime(2101),
// // //     );
// // //     if (selectedDate != null) {
// // //       setState(() {
// // //         _appointmentDate = selectedDate;
// // //       });
// // //     }
// // //   }
// // //
// // //   void _selectTime(BuildContext context) async {
// // //     final selectedTime = await showTimePicker(
// // //       context: context,
// // //       initialTime: TimeOfDay.now(),
// // //     );
// // //     if (selectedTime != null) {
// // //       setState(() {
// // //         _appointmentTime = selectedTime;
// // //       });
// // //     }
// // //   }
// // //
// // //   void _submitAppointment() {
// // //     if (_patientNameController.text.isEmpty ||
// // //         _selectedDoctor == null ||
// // //         _appointmentDate == null ||
// // //         _appointmentTime == null ||
// // //         _selectedHospital.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// // //         content: Text('Please fill all fields!'),
// // //         backgroundColor: Colors.red,
// // //       ));
// // //       return;
// // //     }
// // //
// // //     Appointment appointment = Appointment(
// // //       patientName: _patientNameController.text,
// // //       doctorName: _selectedDoctor!,
// // //       hospitalName: _selectedHospital, // Include hospital name
// // //       date: _appointmentDate!.toLocal().toString().split(' ')[0],
// // //       time: _appointmentTime!.format(context),
// // //     );
// // //
// // //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// // //       content: Text('Appointment Scheduled successfully!'),
// // //       backgroundColor: Colors.green,
// // //     ));
// // //
// // //     print('Scheduled Appointment:');
// // //     print('Patient: ${appointment.patientName}');
// // //     print('Doctor: ${appointment.doctorName}');
// // //     print('Hospital: ${appointment.hospitalName}'); // Print hospital
// // //     print('Date: ${appointment.date}');
// // //     print('Time: ${appointment.time}');
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Schedule Appointment'),
// // //         backgroundColor: Colors.pink,
// // //       ),
// // //       backgroundColor: Colors.white,
// // //       body: Container(
// // //         decoration: BoxDecoration(
// // //           image: DecorationImage(
// // //             image: AssetImage('assets/appointment_bg.jpg'),  // Your image here
// // //             fit: BoxFit.cover,
// // //             colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
// // //           ),
// // //         ),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: SingleChildScrollView(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 // Patient Name Input
// // //                 TextField(
// // //                   controller: _patientNameController,
// // //                   decoration: InputDecoration(
// // //                     labelText: 'Patient Name',
// // //                     border: OutlineInputBorder(),
// // //                     filled: true,
// // //                     fillColor: Colors.white,
// // //                     prefixIcon: Icon(Icons.person, color: Colors.pink),
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 20),
// // //
// // //                 // Hospital Dropdown
// // //                 DropdownButtonFormField<String>(
// // //                   value: _selectedHospital,
// // //                   decoration: InputDecoration(
// // //                     labelText: 'Select Hospital',
// // //                     border: OutlineInputBorder(),
// // //                     filled: true,
// // //                     fillColor: Colors.white,
// // //                   ),
// // //                   onChanged: (newValue) {
// // //                     setState(() {
// // //                       _selectedHospital = newValue!;
// // //                       _selectedDoctor = null; // Reset doctor selection
// // //                     });
// // //                   },
// // //                   items: hospitals.keys.map((hospital) {
// // //                     return DropdownMenuItem<String>(
// // //                       value: hospital,
// // //                       child: Text(hospital),
// // //                     );
// // //                   }).toList(),
// // //                 ),
// // //                 SizedBox(height: 20),
// // //
// // //                 // Doctor Dropdown
// // //                 if (_selectedHospital != null)
// // //                   DropdownButtonFormField<String>(
// // //                     value: _selectedDoctor,
// // //                     decoration: InputDecoration(
// // //                       labelText: 'Select Doctor',
// // //                       border: OutlineInputBorder(),
// // //                       filled: true,
// // //                       fillColor: Colors.white,
// // //                     ),
// // //                     onChanged: (newValue) {
// // //                       setState(() {
// // //                         _selectedDoctor = newValue!;
// // //                       });
// // //                     },
// // //                     items: hospitals[_selectedHospital]!.map((doctor) {
// // //                       return DropdownMenuItem<String>(
// // //                         value: doctor,
// // //                         child: Text(doctor),
// // //                       );
// // //                     }).toList(),
// // //                   ),
// // //                 SizedBox(height: 20),
// // //
// // //                 // Date & Time Pickers
// // //                 Row(
// // //                   children: [
// // //                     // Date Picker
// // //                     Expanded(
// // //                       child: GestureDetector(
// // //                         onTap: () => _selectDate(context),
// // //                         child: InputDecorator(
// // //                           decoration: InputDecoration(
// // //                             labelText: 'Date',
// // //                             border: OutlineInputBorder(),
// // //                             filled: true,
// // //                             fillColor: Colors.white,
// // //                           ),
// // //                           child: Text(
// // //                             _appointmentDate != null
// // //                                 ? _appointmentDate!.toLocal().toString().split(' ')[0]
// // //                                 : 'Select Date',
// // //                             style: TextStyle(color: Colors.black),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     SizedBox(width: 10),
// // //                     // Time Picker
// // //                     Expanded(
// // //                       child: GestureDetector(
// // //                         onTap: () => _selectTime(context),
// // //                         child: InputDecorator(
// // //                           decoration: InputDecoration(
// // //                             labelText: 'Time',
// // //                             border: OutlineInputBorder(),
// // //                             filled: true,
// // //                             fillColor: Colors.white,
// // //                           ),
// // //                           child: Text(
// // //                             _appointmentTime != null
// // //                                 ? _appointmentTime!.format(context)
// // //                                 : 'Select Time',
// // //                             style: TextStyle(color: Colors.black),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 SizedBox(height: 30),
// // //
// // //                 // Submit Button
// // //                 ElevatedButton(
// // //                   onPressed: _submitAppointment,
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: Colors.pink, // Button color
// // //                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(10),
// // //                     ),
// // //                   ),
// // //                   child: Text(
// // //                     'Schedule Appointment',
// // //                     style: TextStyle(fontSize: 18),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:intl/intl.dart'; // For DateFormat
// // // //
// // // // import '../models/appointment.dart'; // Import the Appointment model
// // // //
// // // // class AppointmentPage extends StatefulWidget {
// // // //   @override
// // // //   _AppointmentPageState createState() => _AppointmentPageState();
// // // // }
// // // //
// // // // class _AppointmentPageState extends State<AppointmentPage> {
// // // //   final _patientNameController = TextEditingController();
// // // //   final _doctorNameController = TextEditingController();
// // // //   DateTime? _appointmentDate;
// // // //   TimeOfDay? _appointmentTime;
// // // //   String _selectedHospital = 'Hospital 1'; // Default hospital
// // // //
// // // //   // List of hospitals to choose from
// // // //   final List<String> hospitals = ['Hospital 1', 'Hospital 2', 'Hospital 3'];
// // // //
// // // //   void _selectDate(BuildContext context) async {
// // // //     final selectedDate = await showDatePicker(
// // // //       context: context,
// // // //       initialDate: DateTime.now(),
// // // //       firstDate: DateTime(2023),
// // // //       lastDate: DateTime(2101),
// // // //     );
// // // //     if (selectedDate != null) {
// // // //       setState(() {
// // // //         _appointmentDate = selectedDate;
// // // //       });
// // // //     }
// // // //   }
// // // //
// // // //   void _selectTime(BuildContext context) async {
// // // //     final selectedTime = await showTimePicker(
// // // //       context: context,
// // // //       initialTime: TimeOfDay.now(),
// // // //     );
// // // //     if (selectedTime != null) {
// // // //       setState(() {
// // // //         _appointmentTime = selectedTime;
// // // //       });
// // // //     }
// // // //   }
// // // //
// // // //   void _submitAppointment() {
// // // //     if (_patientNameController.text.isEmpty ||
// // // //         _doctorNameController.text.isEmpty ||
// // // //         _appointmentDate == null ||
// // // //         _appointmentTime == null ||
// // // //         _selectedHospital.isEmpty) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// // // //         content: Text('Please fill all fields!'),
// // // //         backgroundColor: Colors.red,
// // // //       ));
// // // //       return;
// // // //     }
// // // //
// // // //     Appointment appointment = Appointment(
// // // //       patientName: _patientNameController.text,
// // // //       doctorName: _doctorNameController.text,
// // // //       hospitalName: _selectedHospital, // Include hospital name
// // // //       date: _appointmentDate!.toLocal().toString().split(' ')[0],
// // // //       time: _appointmentTime!.format(context),
// // // //     );
// // // //
// // // //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// // // //       content: Text('Appointment Scheduled successfully!'),
// // // //       backgroundColor: Colors.green,
// // // //     ));
// // // //
// // // //     print('Scheduled Appointment:');
// // // //     print('Patient: ${appointment.patientName}');
// // // //     print('Doctor: ${appointment.doctorName}');
// // // //     print('Hospital: ${appointment.hospitalName}'); // Print hospital
// // // //     print('Date: ${appointment.date}');
// // // //     print('Time: ${appointment.time}');
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Schedule Appointment'),
// // // //         backgroundColor: Colors.pink,
// // // //       ),
// // // //       backgroundColor: Colors.white,
// // // //       body: Container(
// // // //         decoration: BoxDecoration(
// // // //           image: DecorationImage(
// // // //             image: AssetImage('assets/appointment_bg.jpg'),  // Your image here
// // // //             fit: BoxFit.cover,
// // // //             colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
// // // //           ),
// // // //         ),
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(16.0),
// // // //           child: SingleChildScrollView(
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 // Patient Name Input
// // // //                 TextField(
// // // //                   controller: _patientNameController,
// // // //                   decoration: InputDecoration(
// // // //                     labelText: 'Patient Name',
// // // //                     border: OutlineInputBorder(),
// // // //                     filled: true,
// // // //                     fillColor: Colors.white,
// // // //                     prefixIcon: Icon(Icons.person, color: Colors.pink),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 20),
// // // //
// // // //                 // Doctor Name Input
// // // //                 TextField(
// // // //                   controller: _doctorNameController,
// // // //                   decoration: InputDecoration(
// // // //                     labelText: 'Doctor Name',
// // // //                     border: OutlineInputBorder(),
// // // //                     filled: true,
// // // //                     fillColor: Colors.white,
// // // //                     prefixIcon: Icon(Icons.local_hospital, color: Colors.pink),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 20),
// // // //
// // // //                 // Hospital Dropdown
// // // //                 DropdownButtonFormField<String>(
// // // //                   value: _selectedHospital,
// // // //                   decoration: InputDecoration(
// // // //                     labelText: 'Select Hospital',
// // // //                     border: OutlineInputBorder(),
// // // //                     filled: true,
// // // //                     fillColor: Colors.white,
// // // //                   ),
// // // //                   onChanged: (newValue) {
// // // //                     setState(() {
// // // //                       _selectedHospital = newValue!;
// // // //                     });
// // // //                   },
// // // //                   items: hospitals.map((hospital) {
// // // //                     return DropdownMenuItem<String>(
// // // //                       value: hospital,
// // // //                       child: Text(hospital),
// // // //                     );
// // // //                   }).toList(),
// // // //                 ),
// // // //                 SizedBox(height: 20),
// // // //
// // // //                 // Date & Time Pickers
// // // //                 Row(
// // // //                   children: [
// // // //                     // Date Picker
// // // //                     Expanded(
// // // //                       child: GestureDetector(
// // // //                         onTap: () => _selectDate(context),
// // // //                         child: InputDecorator(
// // // //                           decoration: InputDecoration(
// // // //                             labelText: 'Date',
// // // //                             border: OutlineInputBorder(),
// // // //                             filled: true,
// // // //                             fillColor: Colors.white,
// // // //                           ),
// // // //                           child: Text(
// // // //                             _appointmentDate != null
// // // //                                 ? _appointmentDate!.toLocal().toString().split(' ')[0]
// // // //                                 : 'Select Date',
// // // //                             style: TextStyle(color: Colors.black),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                     SizedBox(width: 10),
// // // //                     // Time Picker
// // // //                     Expanded(
// // // //                       child: GestureDetector(
// // // //                         onTap: () => _selectTime(context),
// // // //                         child: InputDecorator(
// // // //                           decoration: InputDecoration(
// // // //                             labelText: 'Time',
// // // //                             border: OutlineInputBorder(),
// // // //                             filled: true,
// // // //                             fillColor: Colors.white,
// // // //                           ),
// // // //                           child: Text(
// // // //                             _appointmentTime != null
// // // //                                 ? _appointmentTime!.format(context)
// // // //                                 : 'Select Time',
// // // //                             style: TextStyle(color: Colors.black),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 SizedBox(height: 30),
// // // //
// // // //                 // Submit Button
// // // //                 ElevatedButton(
// // // //                   onPressed: _submitAppointment,
// // // //                   style: ElevatedButton.styleFrom(
// // // //                     backgroundColor: Colors.pink, // Button color
// // // //                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// // // //                     shape: RoundedRectangleBorder(
// // // //                       borderRadius: BorderRadius.circular(10),
// // // //                     ),
// // // //                   ),
// // // //                   child: Text(
// // // //                     'Schedule Appointment',
// // // //                     style: TextStyle(fontSize: 18),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
