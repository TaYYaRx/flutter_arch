import 'package:http/http.dart' as http;

class ApiRepository {
  static const String baseUrlProjeler = 'http://192.168.1.4:3000/api/projeler';
  static const Duration requestTimeout = Duration(seconds: 5);

  Future<String> fetchProjelerFromApi() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrlProjeler))
          .timeout(requestTimeout);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load API');
      }
    } catch (e) {
      //throw Exception('ERROR: Network connection error ::: $e');
      rethrow;
    }
  }

  Future<void> updateProje({
    required String id,
    required String jsonBody,
  }) async {
    try {
      final uriupdateRoute = '$baseUrlProjeler/$id';
      final uri = Uri.parse(uriupdateRoute);

      print('Updating project: $id');
      print('Request body: $jsonBody');

      final response = await http
          .put(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonBody,
          )
          .timeout(requestTimeout);

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
          'Update failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Update error: $e');
      // API'den gelen hatayı olduğu gibi ilet
      if (e.toString().contains('Update failed')) {
        rethrow;
      }
      // Sadece gerçek network hataları için yeni Exception oluştur
      throw Exception('ERROR: Network connection error ::: $e');
    }
  }

  Future<void> addProje({required String jsonBody}) async {
    try {
      final uri = Uri.parse(baseUrlProjeler);
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonBody,
          )
          .timeout(requestTimeout);

      print('Add response status: ${response.statusCode}');
      print('Add response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(
          'Failed to add project: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Add error: $e');
      rethrow;
    }
  }

  Future<void> deleteProje({required String id}) async {
    try {
      final uriDeleteRoute = '$baseUrlProjeler/$id';
      final uri = Uri.parse(uriDeleteRoute);

      final response = await http.delete(uri).timeout(requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to delete project');
      }
    } catch (e) {
      rethrow;
      // throw Exception('ERROR: Network connection error ::: $e');
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