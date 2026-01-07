import 'package:flutter/material.dart';
import '../../../data/exceptions/api_exception.dart';

/// Error display yardımcı sınıfı
/// Exception'ları kullanıcı dostu mesajlara çevirir
class ErrorDisplayHelper {
  /// Exception'dan kullanıcı dostu Türkçe mesaj döndürür
  static String getErrorMessage(Object error) {
    if (error is NetworkException) {
      return error.message;
    } else if (error is TimeoutException) {
      return error.message;
    } else if (error is ValidationException) {
      // Validation hatası varsa field detaylarını da göster
      if (error.failedFields != null && error.failedFields!.isNotEmpty) {
        return '${error.message}\nHatalı alanlar: ${error.failedFields!.join(", ")}';
      }
      return error.message;
    } else if (error is CastErrorException) {
      return '${error.message}\n${error.details?['reason'] ?? ''}';
    } else if (error is DuplicateKeyException) {
      return error.message;
    } else if (error is DatabaseConnectionException) {
      return error.message;
    } else if (error is AuthenticationException) {
      return error.message;
    } else if (error is ServerException) {
      return error.message;
    } else if (error is ApiException) {
      return error.message;
    } else {
      return 'Beklenmeyen bir hata oluştu.\n${error.toString()}';
    }
  }

  /// Exception tipine göre uygun icon döndürür
  static IconData getErrorIcon(Object error) {
    if (error is NetworkException || error is TimeoutException) {
      return Icons.wifi_off;
    } else if (error is ValidationException) {
      return Icons.warning_amber;
    } else if (error is AuthenticationException) {
      return Icons.lock_outline;
    } else if (error is ServerException ||
        error is DatabaseConnectionException) {
      return Icons.cloud_off;
    } else {
      return Icons.error_outline;
    }
  }

  /// Exception tipine göre renk döndürür
  static Color getErrorColor(Object error) {
    if (error is NetworkException || error is TimeoutException) {
      return Colors.red.shade400;
    } else if (error is ValidationException) {
      return Colors.orange.shade400;
    } else if (error is AuthenticationException) {
      return Colors.blue.shade400;
    } else if (error is ServerException ||
        error is DatabaseConnectionException) {
      return Colors.grey.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  /// Hatanın retry edilip edilemeyeceğini kontrol eder
  static bool canRetry(Object error) {
    return error is NetworkException ||
        error is TimeoutException ||
        error is DatabaseConnectionException;
  }

  /// Snackbar ile hata göster
  static void showErrorSnackBar(
    BuildContext context,
    Object error, {
    VoidCallback? onRetry,
  }) {
    final message = getErrorMessage(error);
    final canRetryError = canRetry(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(getErrorIcon(error), color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: getErrorColor(error),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: canRetryError && onRetry != null
            ? SnackBarAction(
                label: 'Tekrar Dene',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }
}

/// Reusable Error Display Widget
class ErrorDisplayWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final String? customMessage;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final message = customMessage ?? ErrorDisplayHelper.getErrorMessage(error);
    final icon = ErrorDisplayHelper.getErrorIcon(error);
    final color = ErrorDisplayHelper.getErrorColor(error);
    final canRetry = ErrorDisplayHelper.canRetry(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 24),
            Text(
              'Bir Hata Oluştu',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700),
            ),
            if (canRetry && onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
