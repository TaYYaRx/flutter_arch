import 'dart:convert';

import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/data/repositories/api_repository.dart';

class ApiService {
  //Veriyi Ham String olarak verir.
  final ApiRepository repository;

  ApiService({required this.repository});

  Future<List<Proje>> fetchProjeler() async {
    final remoteProjelerString = await repository.fetchProjeler();

    final List<dynamic> remoteProjelerList = json.decode(remoteProjelerString);
    final remoteProjeler = remoteProjelerList.map((e) => Proje.fromJson(e as Map<String, dynamic>)).toList();
    return Future.value(remoteProjeler);
  }

  Future<void> updateProje(Proje proje) async {
   // await repository.updateProje(proje);
  }
}
