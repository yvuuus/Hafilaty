import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracking_app/screens/login_screen.dart'; // Import de LoginScreen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextEditingcontroller = TextEditingController();
  final emailEditingcontroller = TextEditingController();
  final passwordTextEditingcontroller = TextEditingController();
  final confirmTextEditingcontroller = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final _formkey = GlobalKey<FormState>();


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

 Future AddData()async{
  var url ="http://192.168.56.1/project/crud/addData.php";
  var res = await http.post(Uri.parse(url),body: {
    'user_name': nameTextEditingcontroller.text,
    'user_email':emailEditingcontroller.text,
    'user_psw':passwordTextEditingcontroller.text
  });

  if(res.statusCode==200){
    var red = jsonDecode(res.body);
    print(red);
  }
 }


  @override
  Widget build(BuildContext context) {
    bool darktheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 207, 176, 221),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Retour à la page précédente
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
              const SizedBox(height: 60), // Réduit l'espace avant l'icône
              Center(
                child:
                    _buildIconCircle(Icons.person, "Passenger"), // Icône centré
              ),
              const SizedBox(
                  height: 20), // Réduit l'espace entre l'icône et le formulaire
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTextFieldWithLabel(
                        controller: nameTextEditingcontroller,
                        label: "Name",
                        hintText: "Name",
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          if (value.length < 2) {
                            return "Name cannot be under 2 characters";
                          }
                          if (value.length > 49) {
                            return "Name cannot be more than 50 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextFieldWithLabel(
                        controller: emailEditingcontroller,
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
                      const SizedBox(height: 10),
                      _buildTextFieldWithLabel(
                        controller: passwordTextEditingcontroller,
                        label: "Password",
                        hintText: "Password",
                        icon: Icons.lock,
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF6A1B9A),
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextFieldWithLabel(
                        controller: confirmTextEditingcontroller,
                        label: "Confirm Password",
                        hintText: "Confirm Password",
                        icon: Icons.lock,
                        obscureText: !_confirmPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != passwordTextEditingcontroller.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF6A1B9A),
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 120,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState?.validate() ?? false) {
                           // Attempt to register user
                           await AddData();
    
                            // Show success message and navigate back
                            ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                                content: const Text(
                                 "Registration successful!",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                             ),
                            );

                           // Navigate back to login screen after a short delay
                           Future.delayed(const Duration(seconds: 2), () {
                             Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(builder: (context) => const LoginScreen()),
                             );
                           });
                         }
                        }
                        ,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        darktheme
                            ? 'images/passenger.png'
                            : 'images/passenger.png',
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 80,
        color: Colors.purple.shade700,
      ),
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
            color: Colors.black,
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
