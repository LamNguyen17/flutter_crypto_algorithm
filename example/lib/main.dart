import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_crypto_algorithm/flutter_crypto_algorithm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _encrypt = 'Unknown';
  String _decrypt = 'Unknown';
  final _flutterCryptoAlgorithmPlugin = FlutterCryptoAlgorithm();

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
          await _flutterCryptoAlgorithmPlugin.encrypt('Hello123', 'Hello') ??
              'Unknown encrypt';
      decrypt = await _flutterCryptoAlgorithmPlugin.decrypt(encrypt, 'Hello') ??
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
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
