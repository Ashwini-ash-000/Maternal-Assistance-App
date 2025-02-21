import 'package:flutter/material.dart';

class PersonalizedDietPage extends StatefulWidget {
  @override
  _PersonalizedDietPageState createState() => _PersonalizedDietPageState();
}

class _PersonalizedDietPageState extends State<PersonalizedDietPage> {
  final _formKey = GlobalKey<FormState>();
  String? trimester;
  double? weight;
  String? dietaryPreference;
  String? healthCondition;

  List<Map<String, String>> mealPlans = [];

  // Generate Meal Plan Logic
  void generateMealPlan() {
    if (!_formKey.currentState!.validate()) return;

    Map<String, String> newMealPlan = {
      "Breakfast": dietaryPreference == "Vegetarian"
          ? "Oatmeal with fresh fruits and a glass of milk"
          : "Eggs with whole-grain toast and fresh juice",
      "Lunch": dietaryPreference == "Vegetarian"
          ? "Lentil soup, brown rice, and sautéed vegetables"
          : "Grilled chicken, brown rice, and steamed vegetables",
      "Snack": healthCondition == "Gestational Diabetes"
          ? "A handful of almonds and a sugar-free yogurt"
          : "A banana with peanut butter",
      "Dinner": dietaryPreference == "Vegetarian"
          ? "Quinoa salad with chickpeas and broccoli"
          : "Fish curry with steamed rice and vegetables",
      "Time": DateTime.now().toString(),
    };

    setState(() {
      mealPlans.add(newMealPlan);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personalized Diet Plan"),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Text(
                "Your Personalized Diet Plan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 20),

              // Trimester Input
              Text("Trimester", style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: trimester,
                onChanged: (value) => setState(() => trimester = value),
                items: ["1st", "2nd", "3rd"]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                validator: (value) =>
                value == null ? "Please select a trimester" : null,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),

              // Weight Input
              Text("Weight (kg)", style: TextStyle(fontSize: 16)),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => weight = double.tryParse(value)),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter your weight"
                    : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your weight",
                ),
              ),
              SizedBox(height: 16),

              // Dietary Preference Input
              Text("Dietary Preference", style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: dietaryPreference,
                onChanged: (value) =>
                    setState(() => dietaryPreference = value),
                items: ["Vegetarian", "Non-Vegetarian", "Vegan"]
                    .map((pref) =>
                    DropdownMenuItem(value: pref, child: Text(pref)))
                    .toList(),
                validator: (value) =>
                value == null ? "Please select a dietary preference" : null,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),

              // Health Condition Input
              Text("Health Condition (if any)", style: TextStyle(fontSize: 16)),
              TextFormField(
                onChanged: (value) => setState(() => healthCondition = value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "E.g., Gestational Diabetes, Anemia",
                ),
              ),
              SizedBox(height: 20),

              // Generate Meal Plan Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: generateMealPlan,
                  icon: Icon(Icons.restaurant_menu),
                  label: Text("Generate Meal Plan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Generated Meal Plans Section
              Text(
                "Generated Meal Plans",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 10),

              // List of Meal Plans
              mealPlans.isEmpty
                  ? Center(
                child: Text(
                  "No meal plans generated yet.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mealPlans.length,
                itemBuilder: (context, index) {
                  final mealPlan = mealPlans[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMealPlanItem(
                              "Breakfast", mealPlan["Breakfast"]!),
                          _buildMealPlanItem(
                              "Lunch", mealPlan["Lunch"]!),
                          _buildMealPlanItem(
                              "Snack", mealPlan["Snack"]!),
                          _buildMealPlanItem(
                              "Dinner", mealPlan["Dinner"]!),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 16, color: Colors.orange),
                              SizedBox(width: 5),
                              Text(
                                "Generated on: ${mealPlan["Time"]}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildMealPlanItem(String title, String details) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              Text(
                details,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
