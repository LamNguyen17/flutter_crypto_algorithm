import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_crypto_algorithm_platform_interface.dart';

/// An implementation of [FlutterCryptoAlgorithmPlatform] that uses method channels.
class MethodChannelFlutterCryptoAlgorithm
    extends FlutterCryptoAlgorithmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_crypto_algorithm');

  @override
  Future<String?> encrypt(
      String value, String privateKey, String? ivKey) async {
    try {
      return await methodChannel.invokeMethod('encrypt', {
        'value': value,
        'privateKey': privateKey,
        if (ivKey != null) 'ivKey': ivKey
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> decrypt(
      String value, String privateKey, String? ivKey) async {
    try {
      return await methodChannel.invokeMethod('decrypt', {
        'value': value,
        'privateKey': privateKey,
        if (ivKey != null) 'ivKey': ivKey
      });
    } catch (e) {
      return null;
    }
  }
}
