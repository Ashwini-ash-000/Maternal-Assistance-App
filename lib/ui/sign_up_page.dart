// import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class SignUpPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFDF6EC),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // App Logo
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.brown.shade200,
//                   child: Icon(
//                     Icons.favorite,
//                     size: 60,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 // App Title
//                 Text(
//                   "Maternal Assistance",
//                   style: GoogleFonts.poppins(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF8B4513),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//
//                 // Subtitle
//                 Text(
//                   "Sign up to start your journey!",
//                   style: GoogleFonts.nunito(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF5D4037),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30),
//
//                 // Email Text Field
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     labelStyle: TextStyle(color: Color(0xFF8B4513)),
//                     prefixIcon: Icon(Icons.email, color: Color(0xFF8B4513)),
//                     filled: true,
//                     fillColor: Colors.white,
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF8B4513), width: 1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF5D4037), width: 2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 // Password Text Field
//                 TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     labelStyle: TextStyle(color: Color(0xFF8B4513)),
//                     prefixIcon: Icon(Icons.lock, color: Color(0xFF8B4513)),
//                     filled: true,
//                     fillColor: Colors.white,
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF8B4513), width: 1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF5D4037), width: 2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//
//                 // Sign Up Button
//                 ElevatedButton(
//                   onPressed: () async {
//                     try {
//                       // await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                         email: emailController.text.trim(),
//                         password: passwordController.text.trim(),
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("Sign-up successful!"),
//                           backgroundColor: Color(0xFF5D4037),
//                         ),
//                       );
//
//                       // Navigate to login page
//                       Navigator.pushReplacementNamed(context, '/login');
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("Sign-up failed: $e"),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF8B4513),
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: Text(
//                     "Sign Up",
//                     style: GoogleFonts.nunito(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 // Already have an account
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/login');
//                   },
//                   child: Text(
//                     "Already have an account? Log in here",
//                     style: GoogleFonts.nunito(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF5D4037),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
