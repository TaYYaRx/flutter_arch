import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../exceptions/api_exception.dart';
import '../models/api_error_response.dart';

class ApiRepository {
  static const String baseUrlProjeler = 'http://192.168.1.4:3000/projeler';
  static const Duration requestTimeout = Duration(seconds: 30);

  Future<String> fetchProjelerFromApi() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrlProjeler))
          .timeout(requestTimeout);

      // ✅ BAŞARILI
      if (response.statusCode == 200) {
        return response.body;
      }

      // ❌ HATA - Backend'den gelen error response'u parse et
      final errorResponse = ApiErrorResponse.fromString(response.body);
      throw ApiException.fromErrorResponse(
        errorResponse,
        statusCode: response.statusCode,
      );
    } on SocketException catch (e) {
      // İnternet bağlantısı yok
      throw NetworkException(
        message: 'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.',
        originalException: e,
      );
    } on TimeoutException {
      // İstek zaman aşımına uğradı
      throw TimeoutException(
        message: 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.',
      );
    } on FormatException catch (e) {
      // JSON parse hatası
      throw ApiException(
        message: 'Sunucudan geçersiz veri geldi',
        errorType: 'FormatException',
        details: {'error': e.toString()},
      );
    } on ApiException {
      // ApiException'ları olduğu gibi yeniden fırlat
      rethrow;
    } catch (e) {
      // Beklenmeyen hatalar
      throw ApiException(
        message: 'Beklenmeyen bir hata oluştu: ${e.toString()}',
        errorType: 'UnexpectedError',
        details: {'error': e.toString()},
      );
    }
  }

  Future<void> updateProje({
    required String id,
    required String jsonBody,
  }) async {
    try {
      final uriupdateRoute = '$baseUrlProjeler/$id';
      final uri = Uri.parse(uriupdateRoute);

      debugPrint('Updating project: $id');
      debugPrint('Request body: $jsonBody');

      final response = await http
          .put(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonBody,
          )
          .timeout(requestTimeout);

      debugPrint('Update response status: ${response.statusCode}');
      debugPrint('Update response body: ${response.body}');

      // ✅ BAŞARILI
      if (response.statusCode == 200) {
        return;
      }

      // ❌ HATA - Backend'den gelen error response'u parse et
      final errorResponse = ApiErrorResponse.fromString(response.body);
      debugPrint('Update error: ${errorResponse.detailedMessage}');

      throw ApiException.fromErrorResponse(
        errorResponse,
        statusCode: response.statusCode,
      );
    } on SocketException catch (e) {
      debugPrint('Update error: Network error');
      throw NetworkException(
        message: 'İnternet bağlantısı yok. Güncelleme başarısız.',
        originalException: e,
      );
    } on TimeoutException {
      debugPrint('Update error: Timeout');
      throw TimeoutException(
        message: 'Güncelleme zaman aşımına uğradı. Lütfen tekrar deneyin.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Update error: Unexpected error - $e');
      throw ApiException(
        message: 'Proje güncellenirken beklenmeyen bir hata oluştu',
        errorType: 'UnexpectedError',
        details: {'error': e.toString(), 'projectId': id},
      );
    }
  }

  Future<void> addProje({required String jsonBody}) async {
    try {
      final uri = Uri.parse(baseUrlProjeler);

      debugPrint('Adding new project');
      debugPrint('Request body: $jsonBody');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonBody,
          )
          .timeout(requestTimeout);

      debugPrint('Add response status: ${response.statusCode}');
      debugPrint('Add response body: ${response.body}');

      // ✅ BAŞARILI (201 Created veya 200 OK)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      // ❌ HATA - Backend'den gelen error response'u parse et
      final errorResponse = ApiErrorResponse.fromString(response.body);
      debugPrint('Add error: ${errorResponse.detailedMessage}');

      throw ApiException.fromErrorResponse(
        errorResponse,
        statusCode: response.statusCode,
      );
    } on SocketException catch (e) {
      debugPrint('Add error: Network error');
      throw NetworkException(
        message: 'İnternet bağlantısı yok. Proje eklenemedi.',
        originalException: e,
      );
    } on TimeoutException {
      debugPrint('Add error: Timeout');
      throw TimeoutException(
        message: 'Proje ekleme zaman aşımına uğradı. Lütfen tekrar deneyin.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Add error: Unexpected error - $e');
      throw ApiException(
        message: 'Proje eklenirken beklenmeyen bir hata oluştu',
        errorType: 'UnexpectedError',
        details: {'error': e.toString()},
      );
    }
  }

  Future<void> deleteProje({required String id}) async {
    try {
      final uriDeleteRoute = '$baseUrlProjeler/$id';
      final uri = Uri.parse(uriDeleteRoute);

      debugPrint('Deleting project: $id');

      final response = await http.delete(uri).timeout(requestTimeout);

      debugPrint('Delete response status: ${response.statusCode}');
      debugPrint('Delete response body: ${response.body}');

      // ✅ BAŞARILI (200 OK veya 204 No Content)
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }

      // ❌ HATA - Backend'den gelen error response'u parse et
      final errorResponse = ApiErrorResponse.fromString(response.body);
      debugPrint('Delete error: ${errorResponse.detailedMessage}');

      throw ApiException.fromErrorResponse(
        errorResponse,
        statusCode: response.statusCode,
      );
    } on SocketException catch (e) {
      debugPrint('Delete error: Network error');
      throw NetworkException(
        message: 'İnternet bağlantısı yok. Proje silinemedi.',
        originalException: e,
      );
    } on TimeoutException {
      debugPrint('Delete error: Timeout');
      throw TimeoutException(
        message: 'Silme işlemi zaman aşımına uğradı. Lütfen tekrar deneyin.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Delete error: Unexpected error - $e');
      throw ApiException(
        message: 'Proje silinirken beklenmeyen bir hata oluştu',
        errorType: 'UnexpectedError',
        details: {'error': e.toString(), 'projectId': id},
      );
    }
  }
}
