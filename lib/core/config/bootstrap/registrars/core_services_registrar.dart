import 'package:dio/dio.dart';

import '../../../../features/chat/presentation/bloc/chat_sync_service.dart';
import '../../../services/api_services.dart';
import '../../../services/auth_interceptor.dart';
import '../../app_config.dart';
import '../../service_locator.dart';

class CoreServicesRegistrar {
  const CoreServicesRegistrar();

  void register() {
    if (!serviceLocator.isRegistered<Dio>()) {
      serviceLocator.registerLazySingleton<Dio>(
        () => Dio(
          BaseOptions(
            baseUrl: AppConfig.instance.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            contentType: 'application/json',
          ),
        )
          ..interceptors.add(AuthInterceptor())
          ..interceptors.add(
            LogInterceptor(requestBody: true, responseBody: false),
          ),
      );
    }
    if (!serviceLocator.isRegistered<ApiServices>()) {
      serviceLocator.registerLazySingleton<ApiServices>(
        () => ApiServices(serviceLocator<Dio>()),
      );
    }
    if (!serviceLocator.isRegistered<ChatSyncService>()) {
      serviceLocator.registerLazySingleton<ChatSyncService>(
        () => ChatSyncService(),
      );
    }
  }
}
