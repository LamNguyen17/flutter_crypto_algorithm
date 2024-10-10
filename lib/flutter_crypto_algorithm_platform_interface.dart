import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_crypto_algorithm_method_channel.dart';

abstract class FlutterCryptoAlgorithmPlatform extends PlatformInterface {
  /// Constructs a FlutterCryptoAlgorithmPlatform.
  FlutterCryptoAlgorithmPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCryptoAlgorithmPlatform _instance = MethodChannelFlutterCryptoAlgorithm();

  /// The default instance of [FlutterCryptoAlgorithmPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCryptoAlgorithm].
  static FlutterCryptoAlgorithmPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCryptoAlgorithmPlatform] when
  /// they register themselves.
  static set instance(FlutterCryptoAlgorithmPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
