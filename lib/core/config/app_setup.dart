import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../services/logger.dart';
import '../utils/app_session.dart';
import 'bootstrap/app_bootstrap_registrars.dart';
import 'bootstrap/app_session_bootstrap.dart';
import 'service_locator.dart';

final GetIt getIt = serviceLocator;

enum AppBootstrapReadiness { idle, bootstrapping, ready, failed }

class AppSetup {
  static const _bootstrapInfrastructure = BootstrapInfrastructureRegistrar();
  static const _coreServicesRegistrar = CoreServicesRegistrar();
  static const _repositoryRegistrar = RepositoryRegistrar();
  static const _useCaseRegistrar = UseCaseRegistrar();
  static const _cubitRegistrar = CubitRegistrar();
  static const _sessionBootstrap = AppSessionBootstrap();

  static final ValueNotifier<AppBootstrapReadiness> bootstrapReadiness =
      ValueNotifier<AppBootstrapReadiness>(AppBootstrapReadiness.idle);

  static Future<void>? _initialBootstrapFuture;
  static Future<void>? _deferredBootstrapFuture;
  static bool _coreServicesReady = false;
  static bool _deferredServicesReady = false;

  static Future<void> prepareForFirstFrame() {
    return _initialBootstrapFuture ??= _runTimed(
      'prepareForFirstFrame',
      () async {
        await _registerBootstrapInfrastructure();
        restoreCachedSession();
      },
    ).catchError((Object error, StackTrace stackTrace) {
      _initialBootstrapFuture = null;
      throw error;
    });
  }

  static Future<void> completeDeferredBootstrap() {
    return _deferredBootstrapFuture ??= _runTimed(
      'completeDeferredBootstrap',
      () async {
        bootstrapReadiness.value = AppBootstrapReadiness.bootstrapping;
        await prepareForFirstFrame();
        await _registerCoreServices();
        await _registerRepositories();
        _registerUseCases();
        _registerCubits();
        await hydrateSessionDetails();
        bootstrapReadiness.value = AppBootstrapReadiness.ready;
        _logEvent('All dependencies registered');
      },
      onError: () {
        bootstrapReadiness.value = AppBootstrapReadiness.failed;
      },
    ).catchError((Object error, StackTrace stackTrace) {
      _deferredBootstrapFuture = null;
      throw error;
    });
  }

  static Future<void> _registerBootstrapInfrastructure() async {
    await _bootstrapInfrastructure.register();
  }

  static Future<void> _registerCoreServices() async {
    if (_coreServicesReady) return;
    _coreServicesRegistrar.register();
    _coreServicesReady = true;
  }

  static Future<void> _registerRepositories() async {
    if (_deferredServicesReady) return;
    _repositoryRegistrar.register();
    _deferredServicesReady = true;
  }

  static void _registerUseCases() {
    _useCaseRegistrar.register();
  }

  static void _registerCubits() {
    _cubitRegistrar.register();
  }

  static void restoreCachedSession() {
    _sessionBootstrap.restoreCachedSession(getIt());
  }

  static Future<void> hydrateSessionDetails() async {
    await _sessionBootstrap.hydrateSessionDetails();
  }

  /// Call on logout — clears session and resets scoped lazy singletons
  static void resetSession() {
    _sessionBootstrap.resetSession();
  }

  @visibleForTesting
  static Future<void> resetForTest() async {
    bootstrapReadiness.value = AppBootstrapReadiness.idle;
    _initialBootstrapFuture = null;
    _deferredBootstrapFuture = null;
    _coreServicesReady = false;
    _deferredServicesReady = false;
    AppSession.clearSession();
    await getIt.reset();
  }

  static void _logEvent(String message) {
    Logger.logEvent(
      className: 'AppSetup',
      event: message,
      methodName: 'bootstrap',
    );
  }

  static Future<void> _runTimed(
    String label,
    Future<void> Function() action, {
    VoidCallback? onError,
  }) async {
    final task = developer.TimelineTask()..start(label);
    final stopwatch = Stopwatch()..start();
    developer.Timeline.instantSync('${label}_started');
    _logEvent('$label started');
    try {
      await action();
      stopwatch.stop();
      developer.Timeline.instantSync(
        '${label}_completed',
        arguments: {'elapsedMs': stopwatch.elapsedMilliseconds},
      );
      _logEvent('$label completed in ${stopwatch.elapsedMilliseconds}ms');
    } catch (error) {
      stopwatch.stop();
      onError?.call();
      developer.Timeline.instantSync(
        '${label}_failed',
        arguments: {
          'elapsedMs': stopwatch.elapsedMilliseconds,
          'error': error.toString(),
        },
      );
      _logEvent('$label failed in ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    } finally {
      task.finish();
    }
  }
}
