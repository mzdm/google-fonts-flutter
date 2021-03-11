part of 'generator.dart';

/// Retrieves a list of [UnrecognizedFont] from errors.json file.
List<UnrecognizedFont> _retrieveUnrecognizedFonts() {
  final file = File(_errorFontsFilePath);
  final unrecognizedFontsList = <UnrecognizedFont>[];

  final fileData = jsonDecode(file.readAsStringSync());
  (fileData as List).forEach((element) {
    try {
      final unrecognizedFont = UnrecognizedFont.fromJson(element);
      unrecognizedFontsList.add(unrecognizedFont);
    } catch (e) {
      print(e);
    }
  });
  return unrecognizedFontsList;
}

/// Retrieves a list of [LanguageFonts] from czech_fonts.json file.
///
/// File source: https://github.com/mzdm/czech_fonts
List<LanguageFonts> _retrieveCzechFonts() {
  const langKey = 'Czech';

  final file = File(_czechFontsFilePath);

  final czechFontsList = <CzechFont>[];

  final data = jsonDecode(file.readAsStringSync());
  (data as List).forEach((element) {
    try {
      final font = CzechFont.fromJson(element);
      czechFontsList.add(font);
    } catch (e) {
      print(e);
    }
  });

  final czechFontNamesList = czechFontsList
      .where((element) => element.confidence == Confidence.HIGHEST)
      .map((e) => e.fontName)
      .toList();

  final languageFonts =
      LanguageFonts(langName: langKey, fontNames: czechFontNamesList);

  return <LanguageFonts>[languageFonts];
}

/// Retrieves a list of [LanguageFonts] from error_handled_fonts.json & fonts.json files.
List<LanguageFonts> _retrieveLangFonts(String path) {
  final file = File(path);
  final langFontsList = <LanguageFonts>[];

  final fileData = jsonDecode(file.readAsStringSync());
  (fileData as List).forEach((element) {
    try {
      final languageFonts = LanguageFonts.fromJson(element);
      langFontsList.add(languageFonts);
    } catch (e) {
      print(e);
    }
  });
  return langFontsList;
}

/// Writes a [list] of data to specified [path] as JSON file.
void _writeToJson<E>(String path, List<E> list) {
  final file = File('$path');
  file.writeAsStringSync(jsonEncode(list));
}

/// Writes a content of String data to specified [customPath].
///
/// If [customPath] is not passed then the path defaults to src/fonts/google_fonts.dart.
Future<void> _writeFile(
  String content, {
  String? customPath,
}) async {
  await File(customPath ?? _generatedFilePath).writeAsString(content);
}
