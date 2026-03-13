/// Flavor-aware configuration. Run with --dart-define=FLAVOR=dev|staging|prod
class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._fromFlavor();

  final String baseUrl;
  final String socketUrl;

  AppConfig._({required this.baseUrl, required this.socketUrl});

  factory AppConfig._fromFlavor() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    switch (flavor) {
      case 'prod':
        return AppConfig._(
          baseUrl: 'https://api.jobhub.com/api/v1',
          socketUrl: 'https://api.jobhub.com',
        );
      case 'staging':
        return AppConfig._(
          baseUrl: 'https://staging.jobhub.com/api/v1',
          socketUrl: 'https://staging.jobhub.com',
        );
      default: // dev
        return AppConfig._(
          // try the android emulator ip address first 10.0.2.2
          // baseUrl: 'http://10.0.2.2:7000/api/v1',
          // socketUrl: 'http://10.0.2.2:7000',

          // if it fails try the physical device network ip ex: 192.168.100.42 
          baseUrl: 'http://192.168.100.42:7000/api/v1',
          socketUrl: 'http://192.168.100.42:7000',
        );
    }
  }

  /// Override instance at runtime (e.g. for physical device testing)
  static void override({required String baseUrl, required String socketUrl}) {
    _instance = AppConfig._(baseUrl: baseUrl, socketUrl: socketUrl);
  }
}
