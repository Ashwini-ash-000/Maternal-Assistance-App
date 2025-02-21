import 'dart:math';
import 'package:flutter/material.dart';
import 'personalized_diet_page.dart';
import 'symptom_to_diet_page.dart';

class DietPage extends StatelessWidget {
  final List<String> dietTips = [
    "Start your day with a nutritious breakfast like oatmeal and fresh fruit.",
    "Include foods rich in iron, like spinach, lentils, and lean meats.",
    "Snack on nuts and seeds to boost your energy throughout the day.",
    "Drink at least 8-10 glasses of water daily to stay hydrated.",
    "Avoid foods like raw fish, unpasteurized cheese, and caffeine.",
    "Add folic acid-rich foods like oranges, broccoli, and beans to your diet.",
    "Dairy products like milk, yogurt, and cheese are great sources of calcium.",
  ];

  final Map<String, List<String>> seasonalDiets = {
    "Summer": [
      "Watermelon, Cucumber, Mint",
      "Curd, Buttermilk, Coconut Water",
      "Seasonal Fruits: Mangoes, Litchis, Pineapples",
    ],
    "Winter": [
      "Sweet Potatoes, Beetroots, Carrots",
      "Seasonal Fruits: Oranges, Guavas, Strawberries",
      "Warm Lentil Soups, Ghee, Dry Fruits",
    ],
    "Monsoon": [
      "Steamed Veggies, Soups",
      "Seasonal Fruits: Apples, Pears, Pomegranates",
      "Herbal Teas, Ginger, Turmeric Milk",
    ],
    "Spring": [
      "Leafy Greens: Spinach, Mustard Greens",
      "Citrus Fruits: Grapefruit, Lemons",
      "Proteins: Lentils, Eggs, Fish",
    ],
  };

  String getRandomTip() {
    final random = Random();
    return dietTips[random.nextInt(dietTips.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet for Mothers-to-Be'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.fastfood,
              size: 80,
              color: Colors.orangeAccent,
            ),
            SizedBox(height: 20),

            // Section: Navigation Buttons for Features
            _buildSectionHeader("Explore More"),
            ElevatedButton.icon(
              icon: Icon(Icons.person, color: Colors.white),
              label: Text("Personalized Diet Plans"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalizedDietPage()),
                );
              },
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.healing, color: Colors.white),
              label: Text("Symptom-to-Diet Suggestions"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SymptomToDietPage()),
                );
              },
            ),
            SizedBox(height: 20),

            // Section: Daily Calorie Intake with Educational Tips
            _buildSectionHeader("Recommended Daily Calorie Intake"),
            Text(
              "1st Trimester: ~1800 calories/day\n"
                  "2nd Trimester: ~2200 calories/day\n"
                  "3rd Trimester: ~2400 calories/day",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Text(
              "Each trimester requires slightly more calories to support the baby’s development. Make sure to choose nutrient-rich foods.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 20),

            // Section: Seasonal Diet Chart
            _buildSectionHeader("Seasonal Diet Chart"),
            ...seasonalDiets.entries.map((entry) {
              return _buildSeasonalDiet(entry.key, entry.value);
            }).toList(),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 20),

            // Section: Daily Tip
            _buildSectionHeader("Daily Tip"),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                getRandomTip(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DietPage()),
                );
              },
              child: Text('Get New Tip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSeasonalDiet(String season, List<String> foods) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$season Diet:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          SizedBox(height: 6),
          ...foods.map((food) {
            return Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    food,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}


// import 'dart:math';
// import 'package:flutter/material.dart';
//
// class DietPage extends StatelessWidget {
//   final List<String> dietTips = [
//     "Start your day with a nutritious breakfast like oatmeal and fresh fruit.",
//     "Include foods rich in iron, like spinach, lentils, and lean meats.",
//     "Snack on nuts and seeds to boost your energy throughout the day.",
//     "Drink at least 8-10 glasses of water daily to stay hydrated.",
//     "Avoid foods like raw fish, unpasteurized cheese, and caffeine.",
//     "Add folic acid-rich foods like oranges, broccoli, and beans to your diet.",
//     "Dairy products like milk, yogurt, and cheese are great sources of calcium.",
//   ];
//
//   final Map<String, List<String>> seasonalDiets = {
//     "Summer": [
//       "Watermelon, Cucumber, Mint",
//       "Curd, Buttermilk, Coconut Water",
//       "Seasonal Fruits: Mangoes, Litchis, Pineapples",
//     ],
//     "Winter": [
//       "Sweet Potatoes, Beetroots, Carrots",
//       "Seasonal Fruits: Oranges, Guavas, Strawberries",
//       "Warm Lentil Soups, Ghee, Dry Fruits",
//     ],
//     "Monsoon": [
//       "Steamed Veggies, Soups",
//       "Seasonal Fruits: Apples, Pears, Pomegranates",
//       "Herbal Teas, Ginger, Turmeric Milk",
//     ],
//     "Spring": [
//       "Leafy Greens: Spinach, Mustard Greens",
//       "Citrus Fruits: Grapefruit, Lemons",
//       "Proteins: Lentils, Eggs, Fish",
//     ],
//   };
//
//   String getRandomTip() {
//     final random = Random();
//     return dietTips[random.nextInt(dietTips.length)];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Diet for Mothers-to-Be'),
//         backgroundColor: Colors.green[700],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.fastfood,
//               size: 80,
//               color: Colors.orangeAccent,
//             ),
//             SizedBox(height: 20),
//
//             // Section: Daily Calorie Intake with Educational Tips
//             _buildSectionHeader("Recommended Daily Calorie Intake"),
//             Text(
//               "1st Trimester: ~1800 calories/day\n"
//                   "2nd Trimester: ~2200 calories/day\n"
//                   "3rd Trimester: ~2400 calories/day",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Each trimester requires slightly more calories to support the baby’s development. Make sure to choose nutrient-rich foods.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             SizedBox(height: 20),
//             Divider(color: Colors.grey),
//             SizedBox(height: 20),
//
//             // Section: Diet Recommendations with Nutritional Info
//             _buildSectionHeader("Diet Recommendations"),
//             _buildFoodGroup("Fruits", Icons.apple, "Oranges, Apples, Bananas, Berries",
//                 "Rich in Vitamin C, supports immune function and collagen formation."),
//             _buildFoodGroup("Vegetables", Icons.grass, "Spinach, Broccoli, Carrots",
//                 "Full of folate, which is essential for fetal neural tube development."),
//             _buildFoodGroup("Proteins", Icons.egg, "Eggs, Lean Meat, Lentils, Beans",
//                 "Vital for tissue growth and muscle development for both mother and baby."),
//             _buildFoodGroup("Grains", Icons.rice_bowl, "Whole Grain Bread, Brown Rice",
//                 "Provides fiber and essential B-vitamins for energy."),
//             _buildFoodGroup("Dairy", Icons.local_drink, "Milk, Yogurt, Cheese",
//                 "Calcium for strong bones and teeth."),
//             SizedBox(height: 20),
//             Divider(color: Colors.grey),
//             SizedBox(height: 20),
//
//             // Section: Seasonal Diet Chart with Health Benefits
//             _buildSectionHeader("Seasonal Diet Chart"),
//             ...seasonalDiets.entries.map((entry) {
//               return _buildSeasonalDiet(entry.key, entry.value);
//             }).toList(),
//             SizedBox(height: 20),
//             Divider(color: Colors.grey),
//             SizedBox(height: 20),
//
//             // Section: Daily Tip with Expert Advice
//             _buildSectionHeader("Daily Tip"),
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.lightGreen[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 getRandomTip(),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Colors.black87),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Refresh for a new tip
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => DietPage()),
//                 );
//               },
//               child: Text('Get New Tip'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.green[700],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFoodGroup(String title, IconData icon, String details, String benefits) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 40, color: Colors.green),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   details,
//                   style: TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//                 SizedBox(height: 6),
//                 Text(
//                   benefits,
//                   style: TextStyle(fontSize: 14, color: Colors.black38),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title) {
//     return Text(
//       title,
//       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     );
//   }
//
//   Widget _buildSeasonalDiet(String season, List<String> foods) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$season Diet:",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//           ),
//           SizedBox(height: 6),
//           ...foods.map((food) {
//             return Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green, size: 16),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     food,
//                     style: TextStyle(fontSize: 16, color: Colors.black87),
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
