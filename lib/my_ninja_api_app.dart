import 'package:flutter/material.dart';
import 'package:proj_my_ninja_api/screens/beranda.dart';
import 'package:proj_my_ninja_api/screens/form_ninja.dart';
import 'package:proj_my_ninja_api/wrapper.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyNinjaAPIApp extends StatelessWidget {
  const MyNinjaAPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Wrapper(),
      routes: {
        "/beranda": (context) {
          return Beranda();
        },
        "/formNinja": (context) {
          return const FormNinja();
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
