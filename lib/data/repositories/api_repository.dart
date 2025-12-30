import 'package:http/http.dart' as http;

class ApiRepository {
  static const String baseUrl = 'http://192.168.1.4:3000';
  
   Future<String> fetchProjeler() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/anaproje'));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load API');
      }
    } catch (e) {
      throw Exception('ERROR: Network connection error ::: $e');
    }
  }
}
