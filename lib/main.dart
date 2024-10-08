import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/user_account/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {},
        child: MaterialApp(
            title: 'pertamina_app',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Color.fromARGB(255, 230, 120, 87))),
            home: LoginPage()));
  }
}
