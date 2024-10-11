import 'flutter_crypto_algorithm_platform_interface.dart';

class Crypto {
  Future<String?> encrypt(String value, String privateKey, {String? ivKey}) {
    return FlutterCryptoAlgorithmPlatform.instance
        .encrypt(value, privateKey, ivKey);
  }

  Future<String?> decrypt(String value, String privateKey, {String? ivKey}) {
    return FlutterCryptoAlgorithmPlatform.instance
        .decrypt(value, privateKey, ivKey);
  }
}
