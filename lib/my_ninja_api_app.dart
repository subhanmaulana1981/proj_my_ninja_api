import 'package:flutter/material.dart';
import 'package:proj_my_ninja_api/screens/beranda.dart';
import 'package:proj_my_ninja_api/screens/form_ninja.dart';
import 'package:proj_my_ninja_api/wrapper.dart';

class MyNinjaAPIApp extends StatelessWidget {
  const MyNinjaAPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Wrapper(),
      routes: {
        "/beranda": (context) {
          return const Beranda();
        },
        "/formNinja": (context) {
          return const FormNinja();
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
