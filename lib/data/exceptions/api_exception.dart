import '../models/api_error_response.dart';

/// Base class for all API exceptions
/// Backend'den gelen error response'ları temsil eder
class ApiException implements Exception {
  final String message;
  final String errorType;
  final int? statusCode;
  final Map<String, dynamic>? details;
  final ApiErrorResponse? errorResponse;

  ApiException({
    required this.message,
    required this.errorType,
    this.statusCode,
    this.details,
    this.errorResponse,
  });

  /// Backend error response'undan exception oluştur
  factory ApiException.fromErrorResponse(
    ApiErrorResponse errorResponse, {
    int? statusCode,
  }) {
    // Error type'a göre özel exception sınıfı döndür
    switch (errorResponse.errorType) {
      case 'ValidationError':
        return ValidationException(
          errorResponse: errorResponse,
          statusCode: statusCode,
        );
      case 'CastError':
        return CastErrorException(
          errorResponse: errorResponse,
          statusCode: statusCode,
        );
      case 'DuplicateKeyError':
        return DuplicateKeyException(
          errorResponse: errorResponse,
          statusCode: statusCode,
        );
      case 'MongoNetworkError':
      case 'MongooseServerSelectionError':
        return DatabaseConnectionException(
          errorResponse: errorResponse,
          statusCode: statusCode,
        );
      case 'JsonWebTokenError':
      case 'TokenExpiredError':
        return AuthenticationException(
          errorResponse: errorResponse,
          statusCode: statusCode,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            errorResponse: errorResponse,
            statusCode: statusCode,
          );
        }
        return UnknownApiException(
          errorResponse: errorResponse,
          statusCode: statusCode,
        );
    }
  }

  @override
  String toString() {
    return 'ApiException(type: $errorType, statusCode: $statusCode, message: $message)';
  }
}

/// Validation errors (400) - Veri doğrulama hataları
class ValidationException extends ApiException {
  ValidationException({
    required ApiErrorResponse errorResponse,
    int? statusCode,
  }) : super(
         message: errorResponse.message,
         errorType: errorResponse.errorType,
         statusCode: statusCode ?? 400,
         details: errorResponse.details,
         errorResponse: errorResponse,
       );

  /// Başarısız olan field'ları döndür
  List<String>? get failedFields {
    if (details != null && details!.containsKey('failedFields')) {
      return List<String>.from(details!['failedFields'] as List);
    }
    return null;
  }

  /// Validation errors listesini döndür
  List<Map<String, dynamic>>? get errors {
    if (errorResponse?.details != null &&
        errorResponse!.details!.containsKey('errors')) {
      return List<Map<String, dynamic>>.from(
        errorResponse!.details!['errors'] as List,
      );
    }
    return null;
  }
}

/// Cast errors (400) - Geçersiz veri formatı
class CastErrorException extends ApiException {
  CastErrorException({required ApiErrorResponse errorResponse, int? statusCode})
    : super(
        message: errorResponse.message,
        errorType: errorResponse.errorType,
        statusCode: statusCode ?? 400,
        details: errorResponse.details,
        errorResponse: errorResponse,
      );

  String? get field => details?['field'] as String?;
  String? get value => details?['value']?.toString();
  String? get expectedType => details?['expectedType'] as String?;
}

/// Duplicate key errors (400) - Tekrar eden kayıt
class DuplicateKeyException extends ApiException {
  DuplicateKeyException({
    required ApiErrorResponse errorResponse,
    int? statusCode,
  }) : super(
         message: errorResponse.message,
         errorType: errorResponse.errorType,
         statusCode: statusCode ?? 400,
         details: errorResponse.details,
         errorResponse: errorResponse,
       );

  String? get field => details?['field'] as String?;
  String? get value => details?['value']?.toString();
}

/// Database connection errors (503) - MongoDB bağlantı hatası
class DatabaseConnectionException extends ApiException {
  DatabaseConnectionException({
    required ApiErrorResponse errorResponse,
    int? statusCode,
  }) : super(
         message: errorResponse.message,
         errorType: errorResponse.errorType,
         statusCode: statusCode ?? 503,
         details: errorResponse.details,
         errorResponse: errorResponse,
       );
}

/// Authentication errors (401) - JWT/Token hataları
class AuthenticationException extends ApiException {
  AuthenticationException({
    required ApiErrorResponse errorResponse,
    int? statusCode,
  }) : super(
         message: errorResponse.message,
         errorType: errorResponse.errorType,
         statusCode: statusCode ?? 401,
         details: errorResponse.details,
         errorResponse: errorResponse,
       );

  DateTime? get expiredAt {
    if (details != null && details!.containsKey('expiredAt')) {
      try {
        return DateTime.parse(details!['expiredAt'] as String);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

/// Server errors (500+) - Sunucu tarafı hataları
class ServerException extends ApiException {
  ServerException({required ApiErrorResponse errorResponse, int? statusCode})
    : super(
        message: errorResponse.message,
        errorType: errorResponse.errorType,
        statusCode: statusCode ?? 500,
        details: errorResponse.details,
        errorResponse: errorResponse,
      );
}

/// Network errors - İnternet bağlantısı/timeout hataları
class NetworkException extends ApiException {
  NetworkException({String? message, Exception? originalException})
    : super(
        message:
            message ??
            'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.',
        errorType: 'NetworkError',
        details: originalException != null
            ? {'originalException': originalException.toString()}
            : null,
      );
}

/// Timeout errors - İstek zaman aşımı
class TimeoutException extends ApiException {
  TimeoutException({String? message})
    : super(
        message:
            message ?? 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.',
        errorType: 'TimeoutError',
      );
}

/// Unknown API errors - Beklenmeyen hatalar
class UnknownApiException extends ApiException {
  UnknownApiException({
    required ApiErrorResponse errorResponse,
    int? statusCode,
  }) : super(
         message: errorResponse.message,
         errorType: errorResponse.errorType,
         statusCode: statusCode,
         details: errorResponse.details,
         errorResponse: errorResponse,
       );
}
