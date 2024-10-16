class Env {
  final String apiScheme;
  final String apiHost;
  final String apiPort;
  final String apiPrefix;
  final String brandHomePageUrl;

  Env({
    required this.apiScheme,
    required this.apiHost,
    required this.apiPort,
    required this.apiPrefix,
    required this.brandHomePageUrl,
  });

  static Env? _instance;

  static Env get instance {
    return _instance!;
  }

  static Future<void> init({
    required String apiScheme,
    required String apiHost,
    required String apiPort,
    required String apiPrefix,
    required String brandHomePageUrl,
  }) async {
    _instance = Env(
      apiScheme: apiScheme,
      apiHost: apiHost,
      apiPort: apiPort,
      apiPrefix: apiPrefix,
      brandHomePageUrl: brandHomePageUrl,
    );
  }

  static Future<void> hardcoded() async {
    await Env.init(
      apiScheme: 'http',
      apiHost: 'localhost',
      apiPort: '8080',
      apiPrefix: 'api',
      brandHomePageUrl: 'https://vivekaa.in',
    );
  }
}
