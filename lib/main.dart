import 'package:flutter/material.dart';
import 'package:maternal_assistance_app/ui/sign_up_page.dart';
import 'ui/login_page.dart';
import 'ui/dashboard_page.dart';
import 'ui/appointment_page.dart'; // Import AppointmentPage
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import notifications
import 'package:timezone/data/latest.dart' as tz; // Import timezone library
import 'package:timezone/timezone.dart' as tz;
import 'ui/sign_up_page.dart';
import 'ui/appointments_dashboard.dart'; // Import AppointmentsDashboard
import 'ui/health_tracker_page.dart'; // Import Health Tracker page
import 'ui/emergency_page.dart'; // Import Emergency Page
import 'ui/forum_page.dart'; // Import the new ForumPage
import 'ui/diet_page.dart';  // Import the diet page
import 'ui/affirmations_page.dart';  // Import the affirmations page

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialization for local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  tz.initializeTimeZones();

  runApp(MaternalAssistanceApp());
}

class MaternalAssistanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maternal Assistance App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        // '/signup': (context) => SignUpPage(),
        '/dashboard': (context) => DashboardPage(),
        '/appointment': (context) => AppointmentPage(),
        '/appointments_dashboard': (context) => AppointmentsDashboard(),
        '/healthTracker': (context) => HealthTrackerPage(),
        '/emergencyContacts': (context) => EmergencyPage(),
        '/forum': (context) => ForumPage(),
        '/diet': (context) => DietPage(),
        '/affirmations': (context) => AffirmationsPage(),
      },
    );
  }
}


