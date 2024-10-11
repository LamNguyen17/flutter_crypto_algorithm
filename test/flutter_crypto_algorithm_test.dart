import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm.dart';
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm_platform_interface.dart';
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCryptoAlgorithmPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCryptoAlgorithmPlatform {

  @override
  Future<String?> encrypt(String value, String privateKey, String? ivKey) => Future.value('IVVM1yR+Cn2Bbxo7RnkAQw==');

  @override
  Future<String?> decrypt(String value, String privateKey, String? ivKey) => Future.value('Hello123');
}

void main() {
  final FlutterCryptoAlgorithmPlatform initialPlatform = FlutterCryptoAlgorithmPlatform.instance;

  test('$MethodChannelFlutterCryptoAlgorithm is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterCryptoAlgorithm>());
  });

  test('encrypt', () async {
    Crypto crypto = Crypto();
    MockFlutterCryptoAlgorithmPlatform fakePlatform = MockFlutterCryptoAlgorithmPlatform();
    FlutterCryptoAlgorithmPlatform.instance = fakePlatform;
    expect(await crypto.encrypt('Hello123', 'Hello'), 'IVVM1yR+Cn2Bbxo7RnkAQw==');
  });

  test('decrypt', () async {
    Crypto crypto = Crypto();
    MockFlutterCryptoAlgorithmPlatform fakePlatform = MockFlutterCryptoAlgorithmPlatform();
    FlutterCryptoAlgorithmPlatform.instance = fakePlatform;
    expect(await crypto.decrypt('IVVM1yR+Cn2Bbxo7RnkAQw==', 'Hello'), 'Hello123');
  });
}
