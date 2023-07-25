import 'package:flutter/material.dart';
import 'package:proj_my_ninja_api/layanans/layanans.dart';
import 'package:proj_my_ninja_api/models/ninja.dart';
import 'package:proj_my_ninja_api/screens/beranda.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<Iterable<Ninja>>.value(
      value: Layanan().fetchNinjas(),
      initialData: const [],
      catchError: (BuildContext context, Object? listNinja) {
        return [];
      },
      child: const Beranda(),
      updateShouldNotify: (previous, current) {
        return current != previous;
      },

    );
  }
}
