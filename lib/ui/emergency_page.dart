//lib/ui/emergency_page.dart

import 'dart:convert'; // For JSON encoding and decoding
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'package:url_launcher/url_launcher.dart'; // For calling feature

class EmergencyContact {
  final String name;
  final String phone;
  final String category; // New field for category

  EmergencyContact({required this.name, required this.phone, required this.category});

  // Convert an EmergencyContact to a Map (for JSON)
  Map<String, String> toJson() {
    return {
      'name': name,
      'phone': phone,
      'category': category,
    };
  }

  // Create an EmergencyContact from a Map (from JSON)
  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phone: json['phone'],
      category: json['category'],
    );
  }
}

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final List<EmergencyContact> _contacts = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedCategory; // New variable for selected category

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Load saved contacts when the page initializes
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedContacts = prefs.getString('emergency_contacts');
    if (savedContacts != null) {
      final List<dynamic> contactList = json.decode(savedContacts);
      setState(() {
        _contacts.addAll(
          contactList.map((contact) => EmergencyContact.fromJson(contact)),
        );
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedContacts =
    json.encode(_contacts.map((contact) => contact.toJson()).toList());
    await prefs.setString('emergency_contacts', encodedContacts);
  }

  void _addContact() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a category.')),
      );
      return;
    }

    if (!RegExp(r'^\d{10,15}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }

    setState(() {
      _contacts.add(EmergencyContact(name: name, phone: phone, category: _selectedCategory!));
    });

    _nameController.clear();
    _phoneController.clear();
    _selectedCategory = null;
    _saveContacts();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Emergency contact added successfully!')),
    );
  }

  void _editContact(int index) {
    final contact = _contacts[index];
    _nameController.text = contact.name;
    _phoneController.text = contact.phone;
    _selectedCategory = contact.category;

    setState(() {
      _contacts.removeAt(index);
    });

    _saveContacts();
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });

    _saveContacts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact deleted successfully!')),
    );
  }

  Future<void> _callContact(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    final PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unable to launch the dialer.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to make phone calls was denied.')),
      );
    }
  }

  Future<void> _sendSOS() async {
    const String message = "SOS! I need help. Please respond immediately!";
    // Add logic to send this message via SMS or other methods.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SOS message sent to emergency contacts.')),
    );
  }

  Future<void> _navigateToHospital() async {
    const String googleMapsUrl = "https://www.google.com/maps/search/hospitals+near+me/";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _sendSOS,
              icon: Icon(Icons.warning),
              label: Text('Send SOS'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: ['Family', 'Doctor', 'Hospital'].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addContact,
              icon: Icon(Icons.add),
              label: Text('Add Contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _contacts.isEmpty
                  ? Center(
                child: Text(
                  'No emergency contacts added yet.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
                  : ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person, color: Colors.white),
                        backgroundColor: Colors.redAccent,
                      ),
                      title: Text(contact.name),
                      subtitle: Text('${contact.phone} (${contact.category})'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editContact(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteContact(index),
                          ),
                          if (contact.category == 'Hospital')
                            IconButton(
                              icon: Icon(Icons.location_on, color: Colors.green),
                              onPressed: _navigateToHospital,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
