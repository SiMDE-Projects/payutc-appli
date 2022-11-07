import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RandomSentences {
  final String filename;

  Locale locale;

  List<String> _sentences = [];

  RandomSentences(this.filename, this.locale);

  Future<void> init() async {
    String data = await rootBundle.loadString("assets/sentences/$filename");
    _sentences = _localeDecoder(jsonDecode(data));
  }

  _localeDecoder(dynamic decoded) {
    return ((decoded[locale.languageCode] ?? decoded.values.first)
            as List<dynamic>)
        .map<String>((e) => e.toString())
        .toList();
  }

  final Random random = Random();
  String get item => _sentences[random.nextInt(_sentences.length)];
  List<String> get items => _sentences;
}
