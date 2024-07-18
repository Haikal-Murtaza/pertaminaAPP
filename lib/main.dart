import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'proses/app_state.dart';
import 'navbar.dart';

// Entry point of the application
void main() {
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provides MyAppState to the widget tree
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'pertamina_app',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 230, 120, 87)),
        ),
        home: NavBar(),
      ),
    );
  }
}
