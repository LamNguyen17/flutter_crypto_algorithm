import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_crypto_algorithm_platform_interface.dart';

/// An implementation of [FlutterCryptoAlgorithmPlatform] that uses method channels.
class MethodChannelFlutterCryptoAlgorithm extends FlutterCryptoAlgorithmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_crypto_algorithm');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
