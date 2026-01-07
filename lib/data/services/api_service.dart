import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/data/repositories/api_repository.dart';

class ApiService {
  //Veriyi Ham String olarak verir.
  final ApiRepository repository;

  ApiService({required this.repository});

  Future<List<Proje>> fetchProjeler() async {
    try {
      final response = await repository.fetchProjelerFromApi();
      //{"success":true,"count":4,"projeler":[...]} şeklinde JSON verisi geliyor.Bu bir sınıf olarak ele alınabilir...
      final decoded = json.decode(response) as Map<String, dynamic>;
      //Tüm Projeleri içeren bir listeye map metodu ile dönüşümü yapılıyor.
      final List projelerJson = decoded['projeler'];

      return projelerJson
          .map((p) => Proje.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e, s) {
      debugPrint('fetchProjeler error: $e');
      debugPrintStack(stackTrace: s);
      return [];
    }
  }

  Future<void> updateProje({required Proje updatedProje}) async {
    final body = jsonEncode(updatedProje.toJson());
    await locator<ApiRepository>().updateProje(
      id: updatedProje.id,
      jsonBody: body,
    );
  }

  Future<void> addProje({required Proje proje}) async {
    // Convert to JSON and remove _id if it's empty to let MongoDB generate it
    final jsonMap = proje.toJson();
    if (jsonMap['_id'] == null || jsonMap['_id'] == '') {
      jsonMap.remove('_id');
    }
    final body = jsonEncode(jsonMap);
    await locator<ApiRepository>().addProje(jsonBody: body);
  }

  Future<void> deleteProje({required String id}) async {
    await locator<ApiRepository>().deleteProje(id: id);
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

/**
 * 
 * class ProjeResponse {
  final bool success;
  final int count;
  final List<Proje> projeler;

  ProjeResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        count = json['count'],
        projeler = (json['projeler'] as List)
            .map((e) => Proje.fromJson(e))
            .toList();
}
 */