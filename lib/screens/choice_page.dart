import 'package:flutter/material.dart';
import 'package:bus_tracking_app/screens/login_screen.dart'; // Import de login_screen.dart

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade100, // Dégradé doux de violet
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const SizedBox(height: 60),
                RoleCard(
                  icon: Icons.person_outline,
                  title: 'Bus Passenger',
                  onTap: () {
                    // Naviguer vers LoginScreen pour le rôle Passenger
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                RoleCard(
                  icon: Icons.directions_bus_outlined,
                  title: 'Bus Driver',
                  onTap: () {
                    // Logique pour Driver (par exemple, redirection ou autre fonctionnalité)
                  },
                ),
                const SizedBox(height: 20),
                RoleCard(
                  icon: Icons.business_outlined,
                  title: 'Bus Agency',
                  onTap: () {
                    // Logique pour Agency (par exemple, redirection ou autre fonctionnalité)
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.deepPurple.shade200,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      Colors.deepPurple.shade100, // Couleur de fond de l'icône
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.deepPurple.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple.shade300,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
