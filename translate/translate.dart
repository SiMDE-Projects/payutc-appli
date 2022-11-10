import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'env.dart';

// use with command dart translate.dart <arb|asset_sentences> <locale,local_2> <source file>
// if arb, the source file is the arb file
// if asset_sentences, the source file is the asset_sentences file and the main locale is the first locale
void main(List<String> args) async {
  if (args.length != 3) {
    print(
        "Usage: dart translate.dart <arb|asset_sentences> <locale,local_2> <source file>");
    print("if arb, the source file is the arb file");
    print(
        "if asset_sentences, the source file is the asset_sentences file and the main locale is the first locale");
    print("Example: dart translate.dart arb en,es,de lib/l10n/intl_fr.arb");
    print(
        "Example: dart translate.dart asset_sentences en,es,de assets/sentences/sentences.json");
    exit(1);
  }
  String command = args.first;
  List<String> locales = args[1].split(",");
  String filePath = args.last;
  File inFile = File(filePath);
  if (!inFile.existsSync()) {
    print("File $filePath does not exist");
    exit(1);
  }
  String fileContent = inFile.readAsStringSync();
  Map<String, dynamic> json = jsonDecode(fileContent);
  switch (command) {
    case "arb":
      for (final locale in locales) {
        await translateArb(json, inFile.parent.path, locale);
      }
      break;
    case "asset_sentences":
      final String mainLocale = json.keys.first;
      Map<String, List<String>> sentences = {};
      for (final locale in locales) {
        if (locale == mainLocale) continue;
        final res =
            await translateAssetSentences(json[mainLocale], mainLocale, locale);
        sentences[locale] = res;
      }
      json.addAll(sentences);
      inFile.writeAsStringSync(jsonEncode(json));
      break;
    default:
      print("Unknown command $command");
      exit(1);
  }
  print("\nTranslation end!\n");
  exit(0);
}

Future<List<String>> translateAssetSentences(
    List<dynamic> sentences, String mainLocale, String locale) async {
  print("\nTranslate asset sentences from $mainLocale to $locale");
  List<String> outSentences = [];
  for (int i = 0; i < sentences.length; i++) {
    String sentence = sentences[i];
    String translation = await translateGoogle(mainLocale, locale, sentence);
    outSentences.add(translation);
    stdout.write("\rTranslating for $locale:(${i + 1}/${sentences.length})");
  }
  return outSentences;
}

Future<void> translateArb(
    Map<String, dynamic> data, String path, String locale) async {
  Map<String, dynamic> out = {};
  int counter = 0;
  if (data["@@locale"] == null) {
    print("\nERROR :: The arb file does not have a valid key locale @@locale");
    exit(1);
  }
  print("Starting translation from ${data["@@locale"]} to $locale");
  for (final entry in data.entries) {
    if (entry.key.startsWith("@") || entry.value is Map) {
      out[entry.key] = entry.value;
    } else {
      try {
        String translated =
            await translateGoogle(data["@@locale"], locale, entry.value);
        out[entry.key] = translated;
      } catch (_) {}
      counter++;
      stdout
          .write("\rTranslating for $locale:($counter/${data.entries.length})");
    }
  }
  out["@@locale"] = locale;
  await File("$path/intl_$locale.arb").writeAsString(jsonEncode(out));
  print("\nEnd !");
  print("File at intl_$locale.arb\n");
}

final Dio client = Dio();

Future<String> translateGoogle(
    String localeIn, String locale, String value) async {
  return client.get("https://translate.googleapis.com/translate_a/single",
      queryParameters: {
        "client": translateClient,
        "sl": "fr",
        "tl": locale,
        "dt": "t",
        "q": value
      }).then((value) {
    return value.data[0][0][0];
  });
}

void print(String message) {
  stdout.writeln(message);
}
