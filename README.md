# flutter_crypto_algorithm

[![Native language](https://img.shields.io/badge/native_language-Kotlin_&_Swift-green)](https://pub.dev/packages/flutter_crypto_algorithm)
[![Code cov](https://codecov.io/gh/LamNguyen17/flutter_crypto_algorithm/branch/master/graph/badge.svg)](https://app.codecov.io/github/LamNguyen17/flutter_crypto_algorithm/blob/master/lib)
[![License](https://img.shields.io/badge/license-MIT-8A2BE2)](https://github.com/LamNguyen17/flutter_crypto_algorithm/blob/master/LICENSE)
[![Author](https://img.shields.io/badge/author-Forest_Nguyen-f59642)](https://github.com/LamNguyen17)

A Flutter package for secure encryption algorithms, providing efficient tools for data protection and encryption operations

## Installation
Run this command with Flutter:
```sh
flutter pub add encryption_algorithm
```

## Usage
### Methods
#### 🚀 AES
```dart
import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm.dart';
```
```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _encrypt = '';
  String _decrypt = '';
  final _crypto = Crypto();

  @override
  void initState() {
    super.initState();
    crypto();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> crypto() async {
    String encrypt;
    String decrypt;
    try {
      encrypt =
          await _crypto.encrypt('Hello123', 'Hello') ??
              'Unknown encrypt';
      decrypt = await _crypto.decrypt(encrypt, 'Hello') ??
          'Unknown decrypt';
    } on PlatformException {
      encrypt = 'Failed encrypt.';
      decrypt = 'Failed decrypt.';
    }
    if (!mounted) return;
    setState(() {
      _encrypt = encrypt;
      _decrypt = decrypt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Crypto Algorithm'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Section(title: 'AES', children: [
                _buildText('Encrypt: ', _encrypt),
                _buildText('Decrypt: ', _decrypt),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String label, String value) {
    return Text.rich(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      TextSpan(
        text: label,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const Section({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...children,
        ],
      ),
    );
  }
}
```

---
## API
### List of Algorithms
- [x] ```AES(Advanced Encryption Standard)```
- [ ] ```SHA-256 (Secure Hash Algorithm)```
- [ ] ```RSA (Rivest-Shamir-Adleman)```
- [ ] ```ChaCha20```
- [ ] ```Blowfish```
- [ ] ```HMAC (Hash-based Message Authentication Code)```
- [ ] ```PBKDF2 (Password-Based Key Derivation Function 2)```
- [ ] ```ECC (Elliptic Curve Cryptography)```
- [ ] ```Scrypt```
- [ ] ```XChaCha20-Poly1305```
---
## Author
    Forest Nguyen
    Email: devlamnt176@gmail.com
---
## License
    MIT License
    Copyright (c) 2024 Forest Nguyen
---

