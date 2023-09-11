import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/server_error_handler.dart';

class ApiServices {
  final Dio _dio;

  ApiServices(this._dio);

  Future<dynamic> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endPoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      throw handleServerError(e);
    }
  }

  Future<dynamic> post({
    required String endPoint,
    required dynamic data,
  }) async {
    try {
      final response = await _dio.post(
        endPoint,
        data: data,
      );
      return response.data;
    } catch (e) {
      throw handleServerError(e);
    }
  }

  Future<dynamic> put({
    required String endPoint,
    required dynamic data,
  }) async {
    try {
      final response = await _dio.put(
        endPoint,
        data: data,
      );
      return response.data;
    } catch (e) {
      throw handleServerError(e);
    }
  }

  Future<dynamic> delete({
    required String endPoint,
  }) async {
    try {
      final response = await _dio.delete(
        endPoint,
      );
      return response.data;
    } catch (e) {
      throw handleServerError(e);
    }
  }

  Future<dynamic> uploadFile({
    required String endPoint,
    required File data,
  }) async {
    final FormData handledData = FormData.fromMap({
      "uploads": await MultipartFile.fromFile(
        data.path,
        filename: data.path.split('/').last,
      ),
    });

    try {
      final response = await _dio.post(
        endPoint,
        data: handledData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );
      return response.data;
    } catch (e) {
      throw handleServerError(e);
    }
  }
}
