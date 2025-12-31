import 'dart:convert';

import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/data/repositories/api_repository.dart';

class ApiService {
  //Veriyi Ham String olarak verir.
  final ApiRepository repository;

  ApiService({required this.repository});

  Future<List<Proje>> fetchProjeler() async {
    final remoteProjelerString = await repository.fetchProjelerFromApi();
    //{"success":true,"count":4,"projeler":[.....]} şeklinde JSON verisi geliyor.
    final List<dynamic> decodedJson = json.decode(remoteProjelerString)['projeler'];
    //Tüm Projeleri içeren bir listeye map metodu ile dönüşümü yapılıyor.
    final List<Proje> decodedList = decodedJson.map((e) => Proje.fromJson(e as Map<String, dynamic>)).toList();
    return Future.value(decodedList);
  }

  Future<void> updateProje({required Proje updatedProje}) async {
    final body = jsonEncode(updatedProje.toJson());
    locator<ApiRepository>().updateProje(id: updatedProje.id, jsonBody: body);
  }
}


/**
 *   Future<List<Proje>> fetchProjeler() async {
    final remoteProjelerString = await repository.fetchProjeler();

    // JSON'u decode et
    final decodedJson = json.decode(remoteProjelerString);

    // Debug: API'den dönen veriyi kontrol et
    print('API Response Type: ${decodedJson.runtimeType}');
    print('API Response: $decodedJson');

    // Eğer Map dönüyorsa, içindeki listeyi al
    final List<dynamic> remoteProjelerList;

    if (decodedJson is Map<String, dynamic>) {
      // API bir obje dönüyor, içindeki listeyi bul
      // Muhtemelen 'data', 'projeler', 'items' gibi bir key altında
      if (decodedJson.containsKey('projeler')) {
        remoteProjelerList = decodedJson['projeler'] as List<dynamic>;
      } else if (decodedJson.containsKey('data')) {
        remoteProjelerList = decodedJson['data'] as List<dynamic>;
      } else {
        // Eğer farklı bir key kullanıyorsa, tüm key'leri göster
        print('Available keys: ${decodedJson.keys}');
        throw Exception('API response is a Map but expected list key not found. Available keys: ${decodedJson.keys}');
      }
    } else if (decodedJson is List<dynamic>) {
      // API direkt liste dönüyor
      remoteProjelerList = decodedJson;
    } else {
      throw Exception('Unexpected API response type: ${decodedJson.runtimeType}');
    }

    final remoteProjeler = remoteProjelerList.map((e) => Proje.fromJson(e as Map<String, dynamic>)).toList();
    return Future.value(remoteProjeler);
  }
 */