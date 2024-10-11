import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterCryptoAlgorithm platform = MethodChannelFlutterCryptoAlgorithm();
  const MethodChannel channel = MethodChannel('flutter_crypto_algorithm');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'encrypt':
            return 'IVVM1yR+Cn2Bbxo7RnkAQw==';
          case 'decrypt':
            return 'Hello123';
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('encrypt', () async {
    expect(await platform.encrypt('Hello123', 'Hello', null), 'IVVM1yR+Cn2Bbxo7RnkAQw==');
  });

  test('decrypt', () async {
    expect(await platform.decrypt('IVVM1yR+Cn2Bbxo7RnkAQw==', 'Hello', null), 'Hello123');
  });
}
