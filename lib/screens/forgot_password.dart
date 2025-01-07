import 'package:bus_tracking_app/screens/login_screen.dart';
import 'package:bus_tracking_app/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracking_app/global/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    firebaseAuth
        .sendPasswordResetEmail(email: emailTextEditingController.text.trim())
        .then((value) {
      Fluttertoast.showToast(
          msg:
              "We have sent you an email to recover your password, please check your email.");
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Error occurred: \n ${error.toString()} ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFE1BEE7),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE1BEE7),
                Color(0xFF9575CD),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              const SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconCircle(Icons.person, "Passenger"),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey, // Form with global key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextFieldWithLabel(
                            controller: emailTextEditingController,
                            label: "Email",
                            hintText: "Email",
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              final emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (!emailRegExp.hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade700,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // Validate form before proceeding
                              if (_formKey.currentState?.validate() ?? false) {
                                _submit();
                              } else {
                                // Show an error if the form is invalid
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please fill all fields"),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Send Reset Password Link",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => LoginScreen()));
                            },
                            child: const Text(
                              "Already have an account? Login",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Image.asset(
                            'images/passenger.png',
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 80,
            color: Colors.purple.shade700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF3E5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF6A1B9A)),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
