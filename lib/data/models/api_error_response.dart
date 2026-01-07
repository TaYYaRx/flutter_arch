import 'dart:convert';

/// Backend'den gelen error response'larını parse etmek için model
/// Backend'in error yapısı:
/// {
///   "success": false,
///   "errorType": "ValidationError|CastError|etc",
///   "message": "Kullanıcıya gösterilecek mesaj",
///   "details": { ... }
/// }
class ApiErrorResponse {
  final bool success;
  final String errorType;
  final String message;
  final Map<String, dynamic>? details;

  ApiErrorResponse({
    required this.success,
    required this.errorType,
    required this.message,
    this.details,
  });

  /// JSON'dan model oluştur
  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      success: json['success'] ?? false,
      errorType: json['errorType'] ?? 'UnknownError',
      message: json['message'] ?? 'Bilinmeyen bir hata oluştu',
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  /// String response'u parse et
  factory ApiErrorResponse.fromString(String responseBody) {
    try {
      final json = jsonDecode(responseBody) as Map<String, dynamic>;
      return ApiErrorResponse.fromJson(json);
    } catch (e) {
      // JSON parse edilemezse default error response döndür
      return ApiErrorResponse(
        success: false,
        errorType: 'ParseError',
        message: 'Sunucudan geçersiz yanıt alındı',
        details: {'originalResponse': responseBody, 'parseError': e.toString()},
      );
    }
  }

  /// Model'i JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'errorType': errorType,
      'message': message,
      'details': details,
    };
  }

  /// Detaylı hata mesajı oluştur (debug için)
  String get detailedMessage {
    final buffer = StringBuffer();
    buffer.writeln('Error Type: $errorType');
    buffer.writeln('Message: $message');

    if (details != null && details!.isNotEmpty) {
      buffer.writeln('Details:');
      details!.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }

    return buffer.toString();
  }

  @override
  String toString() {
    return 'ApiErrorResponse(errorType: $errorType, message: $message, details: $details)';
  }
}
