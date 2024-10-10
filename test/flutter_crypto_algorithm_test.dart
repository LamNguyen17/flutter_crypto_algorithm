import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm.dart';
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm_platform_interface.dart';
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCryptoAlgorithmPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCryptoAlgorithmPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterCryptoAlgorithmPlatform initialPlatform = FlutterCryptoAlgorithmPlatform.instance;

  test('$MethodChannelFlutterCryptoAlgorithm is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterCryptoAlgorithm>());
  });

  test('getPlatformVersion', () async {
    FlutterCryptoAlgorithm flutterCryptoAlgorithmPlugin = FlutterCryptoAlgorithm();
    MockFlutterCryptoAlgorithmPlatform fakePlatform = MockFlutterCryptoAlgorithmPlatform();
    FlutterCryptoAlgorithmPlatform.instance = fakePlatform;

    expect(await flutterCryptoAlgorithmPlugin.getPlatformVersion(), '42');
  });
}
