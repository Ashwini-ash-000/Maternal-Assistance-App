// lib/ui/affirmations_page.dart

import 'dart:math';
import 'package:flutter/material.dart';

class AffirmationsPage extends StatelessWidget {
  final List<String> affirmations = [
    "You are strong and capable.",
    "Your body is doing incredible things for your baby.",
    "Every day brings you closer to meeting your little one.",
    "You are a beautiful, strong, and capable mother.",
    "Believe in yourself and your body's amazing abilities.",
    '"I am strong and capable of handling this journey."',
    '"My body is doing an amazing job to create life."',
    '"I trust in the process and take care of myself."',
    '"I am grateful for my growing family."',
    '"I am confident in my ability to handle motherhood."',
    '"I am deserving of love, support, and self-care."',
    '"Every day, I grow stronger and more confident."',
    '"I trust my instincts and intuition as a mother."',
    '"I am enough, and I am doing my best."',
    '"I embrace the changes in my body with love and gratitude."',
  ];

  String getRandomAffirmation() {
    final random = Random();
    return affirmations[random.nextInt(affirmations.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Affirmations for Expecting Mothers'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                getRandomAffirmation(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Refresh the affirmation
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AffirmationsPage()),
                  );
                },
                child: Text(
                  'Get New Affirmation',
                  style: TextStyle(color: Colors.white), // Text color changed to white
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
