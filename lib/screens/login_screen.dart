import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bus_tracking_app/screens/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracking_app/themeProvider/globals.dart';
import 'btm_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  bool _passwordVisible = false;


  List list =[];
 Future ReadData() async {
  try {
    var url = "http://192.168.56.1/project/crud/readData.php";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      print("ddddddddddddddddDEBUG: Raw Response: ${res.body}");

      var red = jsonDecode(res.body);
      setState(() {
        list.addAll(red);
      });
      print(list);
    } else {
      print("Error fetching data: ${res.statusCode}");
    }
  } catch (e) {
    print("Exception occurred: $e");
  }
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     WidgetsBinding.instance.addPostFrameCallback((_) async {
    await getData(); // Fetch data after the first frame is rendered
  });
  }

  getData()async{
    await ReadData();
  }

  void _checkUserExistence() {
  String email = emailTextEditingController.text.trim();
  String password = passwordTextEditingController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please fill in all fields."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  bool userExists = list.any((user) =>
      user['user_email'] == email && user['user_psw'] == password);

  if (userExists) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login successful!"),
        backgroundColor: Colors.green,
      ),
    );
    loggedInEmail = emailTextEditingController.text;
    // Navigate to the next screen or perform other actions
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  HomePage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Invalid email or password. $list"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 207, 176, 221),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Retourne à la page précédente
            },
          ),
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
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconCircle(Icons.person, "Passenger"),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        _buildTextFieldWithLabel(
                          controller: passwordTextEditingController,
                          label: "Password",
                          hintText: "Password",
                          icon: Icons.lock,
                          obscureText: !_passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 246, 237, 252),
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // Logic for password recovery
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                            _checkUserExistence();
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Image.asset(
                          darkTheme
                              ? 'images/passenger.png'
                              : 'images/passenger.png',
                          fit: BoxFit.contain,
                        ),
                      ],
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
