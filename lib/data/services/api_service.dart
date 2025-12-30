import 'package:flutter_arch/data/repositories/api_repository.dart';

class ApiService {
  //Veriyi Ham String olarak verir.
  final ApiRepository repository;

  ApiService({required this.repository});

  Future<String> fetchProjeler() async {
    return repository.fetchProjeler();
  }
}
