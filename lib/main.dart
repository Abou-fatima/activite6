import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          background: Colors.grey[50],
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}