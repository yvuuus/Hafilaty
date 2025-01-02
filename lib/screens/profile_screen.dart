import 'dart:convert';
import 'package:bus_tracking_app/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bus_tracking_app/themeProvider/globals.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List list = [];
  String? userName; // Variable to store the user name
  bool isLoading = true; // Track loading state

  Future ReadData() async {
    try {
      var url = "http://192.168.56.1/project/crud/readData.php";
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        print("DEBUG: Raw Response: ${res.body}");

        var red = jsonDecode(res.body); // Parse the JSON response
        setState(() {
          list.addAll(red);
          // Find the user by email
          final user = list.firstWhere(
            (element) => element['user_email'] == loggedInEmail,
            orElse: () => null,
          );
          if (user != null) {
            userName = user['user_name']; // Extract the user name
          }
          isLoading = false; // Mark as done loading
        });
        print(list);
      } else {
        print("Error fetching data: ${res.statusCode}");
        setState(() {
          isLoading = false; // Stop loading if there's an error
        });
      }
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        isLoading = false; // Stop loading if there's an exception
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getData(); // Fetch data after the first frame is rendered
    });
  }

  getData() async {
    await ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE1BEE7),
              Color(0xFF9575CD),
              Color(0xFFEDE7F6), // Blanc cassé
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: isLoading
                ? CircularProgressIndicator() // Show loading indicator
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/orange.png'), // Placeholder picture
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Welcome, $userName",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        loggedInEmail ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "We're glad to have you here!",
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white70),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Naviguer vers LoginScreen pour le rôle Passenger
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                          print("Logout pressed");
                        },
                        child: Text("Logout"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the website or support page
                          print("Support or Website button pressed");
                        },
                        child: Text("Support & Website"),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
