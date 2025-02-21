import 'package:flutter/material.dart';
import 'appointment_page.dart';
import 'health_tracker_page.dart';
import 'emergency_page.dart';
import 'forum_page.dart';
import 'diet_page.dart';  // Import the Diet page
import 'affirmations_page.dart';  // Import the Affirmations page

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          _buildFeatureTile(context, 'Appointments', Icons.calendar_today, AppointmentPage()),
          _buildFeatureTile(context, 'Health Tracker', Icons.health_and_safety, HealthTrackerPage()),
          _buildFeatureTile(context, 'Emergency Contacts', Icons.phone, EmergencyPage()),
          _buildFeatureTile(context, 'Forum', Icons.forum, ForumPage()),
          _buildFeatureTile(context, 'Diet for Mothers-to-Be', Icons.restaurant_menu, DietPage()),  // New tile for Diet
          _buildFeatureTile(context, 'Affirmations', Icons.favorite, AffirmationsPage()),  // New tile for Affirmations
        ],
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Card(
        color: Colors.pink[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.pink),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
