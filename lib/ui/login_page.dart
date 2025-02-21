import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Error messages
  String errorMessage = '';

  // Validate email format using regular expression
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  // Handle login
  void handleLogin() {
    setState(() {
      errorMessage = ''; // Clear previous error messages

      // Check if email is valid
      if (!isValidEmail(emailController.text)) {
        errorMessage = 'Please enter a valid email address';
        return;
      }

      // Check if password is not empty
      if (passwordController.text.isEmpty) {
        errorMessage = 'Please enter your password';
        return;
      }

      // Example: Simple hardcoded login check (replace this with real authentication logic)
      if (emailController.text == 'ash@gmail.com' && passwordController.text == 'ash123') {
        // Successful login - navigate to dashboard
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Color(0xFF5D4037),
        ));

        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Invalid credentials
        errorMessage = 'Invalid email or password';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6EC), // Soft beige background
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.brown.shade200,
                  child: Icon(
                    Icons.favorite,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // App Title
                Text(
                  "Maternal Assistance",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513), // Rich brown
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Subtitle
                Text(
                  "Your journey to safe and informed motherhood starts here!",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037), // Dark brown
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // Email Text Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Color(0xFF8B4513)),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF8B4513)),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF8B4513), width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5D4037), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Password Text Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Color(0xFF8B4513)),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF8B4513)),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF8B4513), width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5D4037), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Error message
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4513), // Rich brown button
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Additional Notes
                Text(
                  "Note: Always keep your credentials secure. If you face any issues, feel free to reach out to us.",
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5D4037), // Dark brown
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
