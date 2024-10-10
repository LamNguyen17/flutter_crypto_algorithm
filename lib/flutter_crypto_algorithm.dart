
import 'flutter_crypto_algorithm_platform_interface.dart';

class FlutterCryptoAlgorithm {
  Future<String?> getPlatformVersion() {
    return FlutterCryptoAlgorithmPlatform.instance.getPlatformVersion();
  }
}
