import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vital_sign.dart';

class HealthTrackerPage extends StatefulWidget {
  @override
  _HealthTrackerPageState createState() => _HealthTrackerPageState();
}

class _HealthTrackerPageState extends State<HealthTrackerPage> {
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  List<VitalSign> vitalSigns = [];

  @override
  void initState() {
    super.initState();
    _loadHealthData(); // Load saved data on initialization
  }

  @override
  void dispose() {
    _bloodPressureController.dispose();
    _heartRateController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _addVitalSign() async {
    if (_bloodPressureController.text.isNotEmpty &&
        _heartRateController.text.isNotEmpty &&
        _temperatureController.text.isNotEmpty &&
        _weightController.text.isNotEmpty) {
      final bloodPressure = double.parse(_bloodPressureController.text);
      final heartRate = double.parse(_heartRateController.text);
      final temperature = double.parse(_temperatureController.text);
      final weight = double.parse(_weightController.text);

      setState(() {
        vitalSigns.add(VitalSign(
          bloodPressure: bloodPressure,
          heartRate: heartRate,
          temperature: temperature,
          weight: weight,
          timestamp: DateTime.now(),
        ));
      });

      _bloodPressureController.clear();
      _heartRateController.clear();
      _temperatureController.clear();
      _weightController.clear();

      await _saveHealthData(); // Save the updated data
    }
  }

  Future<void> _saveHealthData() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(
      vitalSigns.map((vital) => vital.toJson()).toList(),
    );
    await prefs.setString('health_data', data);
  }

  Future<void> _loadHealthData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('health_data');
    if (data != null) {
      setState(() {
        vitalSigns = (jsonDecode(data) as List)
            .map((item) => VitalSign.fromJson(item))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Tracker'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome and motivational thoughts
              Card(
                color: Colors.teal[50],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🌟 Welcome to Your Health Tracker! 🌟",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "💡 Thought for the Day:\n\n"
                            "“Taking small steps every day towards a healthy lifestyle ensures the well-being of both you and your baby.”",
                        style: TextStyle(fontSize: 16, color: Colors.teal[700]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Input section
              Text(
                "📝 Log Your Vital Signs",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _bloodPressureController,
                decoration: InputDecoration(
                  labelText: 'Blood Pressure (e.g., 120)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monitor_heart, color: Colors.teal),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _heartRateController,
                decoration: InputDecoration(
                  labelText: 'Heart Rate (e.g., 80)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.favorite, color: Colors.redAccent),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _temperatureController,
                decoration: InputDecoration(
                  labelText: 'Body Temperature (e.g., 98.6)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.thermostat, color: Colors.orangeAccent),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (in kg, e.g., 70)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center, color: Colors.green),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addVitalSign,
                icon: Icon(Icons.add),
                label: Text("Add Vital Sign"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Health Logs Section
              Text(
                "📊 Your Health Logs",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              vitalSigns.isEmpty
                  ? Center(
                child: Text(
                  "No health data logged yet. Start adding your vital signs to see them here!",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: vitalSigns.length,
                itemBuilder: (context, index) {
                  final vitalSign = vitalSigns[index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.health_and_safety, color: Colors.teal),
                      title: Text(
                        "Blood Pressure: ${vitalSign.bloodPressure}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Heart Rate: ${vitalSign.heartRate}, Temperature: ${vitalSign.temperature}, Weight: ${vitalSign.weight} kg",
                      ),
                      trailing: Text(
                        "${vitalSign.timestamp.day}/${vitalSign.timestamp.month}/${vitalSign.timestamp.year}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
