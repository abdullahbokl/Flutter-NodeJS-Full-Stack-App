import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  Failure(this.message);
}

class _ServerErrorHandler extends Failure {
  _ServerErrorHandler(super.message);

  factory _ServerErrorHandler.fromDiorError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return _ServerErrorHandler('Connection timeout with api server');

      case DioExceptionType.sendTimeout:
        return _ServerErrorHandler('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return _ServerErrorHandler('Receive timeout with ApiServer');
      case DioExceptionType.badCertificate:
        return _ServerErrorHandler('badCertificate with api server');
      case DioExceptionType.badResponse:
        return _ServerErrorHandler.fromResponse(
            e.response!.statusCode!, e.response!.data);
      case DioExceptionType.cancel:
        return _ServerErrorHandler('Request to ApiServer was canceled');
      case DioExceptionType.connectionError:
        return _ServerErrorHandler('No Internet Connection');
      case DioExceptionType.unknown:
        return _ServerErrorHandler('Oops There was an Error, Please try again');
    }
  }

  factory _ServerErrorHandler.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 404) {
      if (response['message'] != null) {
        return _ServerErrorHandler(response['message']);
      }
      return _ServerErrorHandler(
          'Your request was not found, please try later');
    } else if (statusCode < 500) {
      return _ServerErrorHandler(response['message']);
    } else if (statusCode == 500) {
      return _ServerErrorHandler(
          'There is a problem with server, please try later');
    } else {
      return _ServerErrorHandler('There was an error , please try again');
    }
  }
}

String handleServerError(e) {
  String error = _ServerErrorHandler(e.toString()).message;
  if (e is DioException) {
    error = _ServerErrorHandler.fromDiorError(e).message;
  }
  return error;
}
