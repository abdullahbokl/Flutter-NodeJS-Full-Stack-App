import 'package:dio/dio.dart';
import 'failures.dart';

/// Maps a [DioException] or generic exception to a typed [Failure].
Failure mapToFailure(Object e) {
  if (e is DioException) return _mapDioException(e);
  if (e is Failure) return e;
  return UnknownFailure(e.toString());
}

Failure _mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
      return const NetworkFailure();
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const NetworkFailure('Request timed out');
    case DioExceptionType.badResponse:
      return _mapStatusCode(e.response?.statusCode, e.response?.data);
    case DioExceptionType.cancel:
      return const UnknownFailure('Request cancelled');
    default:
      return UnknownFailure(e.message ?? 'Unknown error');
  }
}

Failure _mapStatusCode(int? code, dynamic data) {
  final msg = data is Map ? (data['message'] ?? '') : '';
  return switch (code) {
    400 => ValidationFailure(msg.isNotEmpty ? msg : 'Invalid request'),
    401 => const AuthFailure(),
    403 => const AuthFailure('Access forbidden'),
    404 => NotFoundFailure(msg.isNotEmpty ? msg : 'Resource not found'),
    409 => ConflictFailure(msg.isNotEmpty ? msg : 'Conflict'),
    _ => ServerFailure(msg.isNotEmpty ? msg : 'Server error'),
  };
}

