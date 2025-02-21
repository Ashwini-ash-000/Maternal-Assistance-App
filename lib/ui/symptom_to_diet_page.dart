import 'package:flutter/material.dart';

class SymptomToDietPage extends StatelessWidget {
  final Map<String, List<String>> symptomFoods = {
    "Nausea": ["Ginger Tea", "Plain Crackers", "Peppermint", "Bananas"],
    "Swelling": ["Cucumber", "Watermelon", "Low-Sodium Foods", "Potassium-Rich Foods"],
    "Fatigue": ["Almonds", "Spinach", "Lean Meat", "Oatmeal"],
    "Heartburn": ["Milk", "Yogurt", "Steamed Vegetables", "Low-Acid Fruits"],
    "Constipation": ["Whole Grains", "Prunes", "Leafy Greens", "Water"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Symptom Checker"),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: symptomFoods.keys.length,
        itemBuilder: (context, index) {
          String symptom = symptomFoods.keys.elementAt(index);
          List<String> foods = symptomFoods[symptom]!;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              title: Text(
                symptom,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Suggested Foods: ${foods.join(', ')}"),
              trailing: Icon(Icons.arrow_forward, color: Colors.purple),
              onTap: () {
                // Show details for the symptom
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Foods for $symptom"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: foods.map((food) => Text("- $food")).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
