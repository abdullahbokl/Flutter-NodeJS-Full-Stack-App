import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerErrorHandler extends Failure {
  ServerErrorHandler(super.message);

  factory ServerErrorHandler.fromDiorError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerErrorHandler('Connection timeout with api server');

      case DioExceptionType.sendTimeout:
        return ServerErrorHandler('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerErrorHandler('Receive timeout with ApiServer');
      case DioExceptionType.badCertificate:
        return ServerErrorHandler('badCertificate with api server');
      case DioExceptionType.badResponse:
        return ServerErrorHandler.fromResponse(
            e.response!.statusCode!, e.response!.data);
      case DioExceptionType.cancel:
        return ServerErrorHandler('Request to ApiServer was canceled');
      case DioExceptionType.connectionError:
        return ServerErrorHandler('No Internet Connection');
      case DioExceptionType.unknown:
        return ServerErrorHandler('Oops There was an Error, Please try again');
    }
  }

  factory ServerErrorHandler.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerErrorHandler(response['message']);
    } else if (statusCode == 404) {
      if (response['message'] != null) {
        return ServerErrorHandler(response['message']);
      }
      return ServerErrorHandler('Your request was not found, please try later');
    } else if (statusCode == 500) {
      return ServerErrorHandler(
          'There is a problem with server, please try later');
    } else {
      return ServerErrorHandler('There was an error , please try again');
    }
  }
}

String handleServerError(e) {
  String error = ServerErrorHandler(e.toString()).message;
  if (e is DioException) {
    error = ServerErrorHandler.fromDiorError(e).message;
  }
  return error;
}
