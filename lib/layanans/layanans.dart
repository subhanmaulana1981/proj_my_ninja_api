import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proj_my_ninja_api/models/ninja.dart';

class Layanan {
  // method to get all ninjas
  Future<List<Ninja>> fetchNinjas() async {
    Uri uriURL = Uri.http("154.56.39.55:4000", "/api/ninjas");
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.get(uriURL, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      // print(response.body);
      final List listNinjasFromAPI = jsonDecode(response.body);
      List<Ninja> listNinjas = (listNinjasFromAPI.isNotEmpty)
          ? listNinjasFromAPI.map<Ninja>((ninja) {
              return Ninja.fromJson(ninja);
            }).toList()
          : [];

      return listNinjas;
    } else {
      throw Exception("Failed to load Ninjas");
    }
  }
  
  // method to get a (one) ninja
  Future<Ninja> fetchNinja(String stringID) async {
    Uri uriURL = Uri.http("154.56.39.55:4000", "/api/ninjas/$stringID");
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.get(uriURL, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      // print(response.body);
      final Ninja ninja = Ninja.fromJson(jsonDecode(response.body));

      return ninja;
    } else {
      throw Exception("Failed to load a Ninja");
    }
  }

}
