import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.note_alt,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Mes Notes',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gérez vos notes en toute simplicité',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Se connecter'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Créer un compte'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}