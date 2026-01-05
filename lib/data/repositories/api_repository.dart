import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiRepository {
  static const String baseUrlProjeler = 'http://192.168.1.4:3000/projeler';

  Future<String> fetchProjelerFromApi() async {
    try {
      final response = await http.get(Uri.parse(baseUrlProjeler));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load API');
      }
    } catch (e) {
      throw Exception('ERROR: Network connection error ::: $e');
    }
  }

  Future<void> updateProje({required String id, required String jsonBody}) async {
    try {
      final uriupdateRoute = '$baseUrlProjeler/$id';
      final uri = Uri.parse(uriupdateRoute);

      debugPrint('Updating project: $id');
      debugPrint('Request body: $jsonBody');

      final response = await http.put(uri, headers: {'Content-Type': 'application/json'}, body: jsonBody);

      debugPrint('Update response status: ${response.statusCode}');
      debugPrint('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Update failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Update error: $e');
      throw Exception('ERROR: Network connection error ::: $e');
    }
  }

  Future<void> addProje({required String jsonBody}) async {
    try {
      final uri = Uri.parse(baseUrlProjeler);
      final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to add project');
      }
    } catch (e) {
      throw Exception('ERROR: Network connection error ::: $e');
    }
  }

  Future<void> deleteProje({required String id}) async {
    try {
      final uriDeleteRoute = '$baseUrlProjeler/$id';
      final uri = Uri.parse(uriDeleteRoute);

      final response = await http.delete(uri);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to delete project');
      }
    } catch (e) {
      throw Exception('ERROR: Network connection error ::: $e');
    }
  }
}


/**
//TODO:: Hata yönetimi ele alınacak. 
final decodedBody = jsonDecode(response.body);

    // ✅ BAŞARILI
    if (response.statusCode == 200) {
      return;
    }

    // ❌ CLIENT HATALARI
    if (response.statusCode == 400 || response.statusCode == 404) {
      throw Exception(decodedBody['message'] ?? 'İşlem başarısız');
    }

    // ❌ SERVER HATASI
    if (response.statusCode >= 500) {
      throw Exception('Sunucu hatası. Lütfen tekrar deneyin.');
    }

    // ❌ BEKLENMEYEN
    throw Exception('Bilinmeyen hata oluştu');

  } on SocketException {
    throw Exception('İnternet bağlantısı yok');
  } on FormatException {
    throw Exception('Sunucudan geçersiz veri geldi');
  }
 */