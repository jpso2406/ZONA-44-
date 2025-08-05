import 'package:flutter/material.dart';
import 'package:zona44app/screens/home/homeadmin_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zona 44',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeAdminScreen(), // o el nombre exacto de tu widget de dashboard

      // Puedes agregar rutas aquí si lo deseas más adelante:
      // routes: {
      //   '/home': (context) => const HomeScreen(),
      //   '/login': (context) => const LoginScreen(),
      // },
    );
  }
}
