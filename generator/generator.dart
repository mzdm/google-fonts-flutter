// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:console/console.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mustache_template/mustache_template.dart';

import 'fonts.pb.dart' as pb;
import 'models/czech_font.dart';
import 'models/font.dart';
import 'models/language_fonts.dart';

part 'file_utils.dart';

part 'generator_helper.dart';

/// If [args] contains:
/// - either --fetch-langs argument then each font is checked via Google Fonts API
/// and written to fonts.json file, if any a language of the font was not possible
/// to recognize then that font is written to `errors.json`,
/// - or --try-handle-errors argument then each font from errors.json is
/// tried to be fetched from a different API.
///
/// To just generate the [GoogleFonts] private class and public classes for language fonts
/// then run it without any arguments (running it with arguments
/// will not generate the final base & language .dart files).
Future<void> main(List<String> args) async {
  final fonts = <LanguageFonts>[];
  final errorHandledFonts = <LanguageFonts>[];

  print('\nGetting latest font directory...');
  final protoUrl = await _getProtoUrl();
  print('Success! Using $protoUrl');

  final fontDir = await _readFontsProtoData(protoUrl);

  print('\nValidating font URLs and file contents...');
  await _verifyUrls(fontDir);
  print(_successMessage);

  print('\nRetrieving handled fonts from error_handled_fonts.json file...');
  errorHandledFonts.addAll(_retrieveLangFonts(_errorHandledLangFontsFilePath));
  print(_successMessage);

  if (args.contains('--fetch-langs')) {
    await _runFetchLangs(fontDir, errorHandledFonts, fonts);
    return;
  } else if (args.contains('--try-handle-errors')) {
    await _runTryHandleErrors(errorHandledFonts);
    return;
  }

  print('\nRetrieving fonts from fonts.json file...');
  fonts.addAll(_retrieveLangFonts(_langFontsFilePath));
  print(_successMessage);

  print('\nRetrieving Czech fonts from czech_fonts.json file...');
  fonts.addAll(_retrieveCzechFonts());
  print(_successMessage);

  print('\nConcatenating fonts from these files...');
  final concatenated = _concatenateLanguageFonts([errorHandledFonts, fonts]);
  print(_successMessage);

  // splits google_fonts.dart (https://github.com/mzdm/google-language-fonts-flutter/issues/7)
  print('\nSplitting to individual language files...');
  final concatenatedTempList = List<LanguageFonts>.from(concatenated);
  await _splitLangFiles(concatenated, fontDir, concatenatedTempList);
  print(_successMessage);

  print('\nGenerating main lib file $_generatedFilePath...');
  await _writeFile(_generateDartCode(fontDir, concatenatedTempList));
  print(_successMessage);
}

Future<void> _runFetchLangs(
  pb.Directory fontDir,
  List<LanguageFonts> errorHandledFonts,
  List<LanguageFonts> fonts,
) async {
  print('\nFetching fonts with language subsets (~1-2 minutes)...');
  final allFontNames = (fontDir.family).map((font) => font.name).toList();
  final fetchedFonts = await _fetchLanguages(errorHandledFonts, allFontNames);
  fonts.addAll(fetchedFonts);
  print(_successMessage);

  print('\nWriting fetched fonts to fonts.json...');
  _writeToJson(_langFontsFilePath, fonts);
  print(_successMessage);
}

Future<void> _runTryHandleErrors(List<LanguageFonts> errorHandledFonts) async {
  print('\nReading unrecognized fonts from errors.json...');
  final unrecognizedFonts = _retrieveUnrecognizedFonts();
  print(_successMessage);

  print('\nTrying to fetch unrecognized fonts with an API alternative...');
  final fetchedFonts = await _tryFetchUnrecognizedFontsLangs(unrecognizedFonts);
  print(_successMessage);

  print('\nConcatenating already handled fonts & newly recognized fonts...');
  final concatenated =
      _concatenateLanguageFonts([errorHandledFonts, fetchedFonts]);
  print(_successMessage);

  print('\nWriting fetched fonts to error_handled_fonts.json file...');
  _writeToJson(_errorHandledLangFontsFilePath, concatenated);
  print(_successMessage);
}

/// Splits [GoogleFonts] class to individual [LanguageFonts] classes.
///
/// If [concatenated] parameter contains an object where property **fontNames** of [LanguageFonts]
/// is empty, then that [LanguageFonts] object is removed from the list to not occur
/// in imports in [GoogleFonts] class and as empty language class.
Future _splitLangFiles(
  List<LanguageFonts> concatenated,
  pb.Directory fontDir,
  List<LanguageFonts> concatenatedTempList,
) async {
  for (var i = 0; i < concatenated.length; i++) {
    final languageFonts = concatenated[i];
    if (languageFonts.fontNames.isNotEmpty) {
      final langName = languageFonts.langName;
      final path = _getGeneratedLangFilePath(langName);
      print('Generating $path...');
      await _writeFile(
        _generateDartCode(fontDir, concatenated, currLangName: langName),
        customPath: path,
      );
    } else {
      concatenatedTempList.remove(languageFonts);
    }
  }
}

/// Gets the latest font directory.
///
/// Versioned directories are hosted on the Google Fonts server. We try to fetch
/// each directory one by one until we hit the last one. We know we reached the
/// end if requesting the next version results in a 404 response.
/// Other types of failure should not occur. For example, if the internet
/// connection gets lost while downloading the directories, we just crash. But
/// that's okay for now, because the generator is only executed in trusted
/// environments by individual developers.
Future<String> _getProtoUrl({int initialVersion = 1}) async {
  var directoryVersion = initialVersion;

  String url(int directoryVersion) {
    final paddedVersion = directoryVersion.toString().padLeft(3, '0');
    return 'http://fonts.gstatic.com/s/f/directory$paddedVersion.pb';
  }

  var didReachLatestUrl = false;
  final httpClient = http.Client();
  while (!didReachLatestUrl) {
    final response = await httpClient.get(Uri.parse(url(directoryVersion)));
    if (response.statusCode == 200) {
      directoryVersion += 1;
    } else if (response.statusCode == 404) {
      didReachLatestUrl = true;
      directoryVersion -= 1;
    } else {
      throw Exception('Request failed: $response');
    }
  }
  httpClient.close();

  return url(directoryVersion);
}

Future<void> _verifyUrls(pb.Directory fontDirectory) async {
  final totalFonts =
      fontDirectory.family.map((f) => f.fonts.length).reduce((a, b) => a + b);
  final progressBar = ProgressBar(complete: totalFonts);

  final client = http.Client();

  for (final family in fontDirectory.family) {
    for (final font in family.fonts) {
      final urlString =
          'https://fonts.gstatic.com/s/a/${_hashToString(font.file.hash)}.ttf';
      await _tryUrl(client, urlString, font);
      progressBar.update(progressBar.current + 1);
    }
  }
  client.close();
}

Future<void> _tryUrl(http.Client client, String url, pb.Font font) async {
  try {
    final fileContents = await client.get(Uri.parse(url));
    final actualFileLength = fileContents.bodyBytes.length;
    final actualFileHash = sha256.convert(fileContents.bodyBytes).toString();
    if (font.file.fileSize != actualFileLength ||
        _hashToString(font.file.hash) != actualFileHash) {
      throw Exception('Font from $url did not match length of or checksum.');
    }
  } catch (e) {
    print('Failed to load font from url: $url');
    rethrow;
  }
}

String _hashToString(List<int> bytes) {
  var fileName = '';
  for (final byte in bytes) {
    final convertedByte = byte.toRadixString(16).padLeft(2, '0');
    fileName += convertedByte;
  }
  return fileName;
}

Future<pb.Directory> _readFontsProtoData(String protoUrl) async {
  final fontsProtoFile = await http.get(Uri.parse(protoUrl));
  return pb.Directory.fromBuffer(fontsProtoFile.bodyBytes);
}

/// Fetches Google Fonts API data and creates from it a list with
/// [LanguageFonts] objects where:
/// - langName property is language name (Arabic, Latin, Cyrillic, ...),
/// - fontNames property is a list of [String]s which contains its supported font names.
Future<List<LanguageFonts>> _fetchLanguages(
  List<LanguageFonts> errorHandledFonts,
  List<String> allFontNames,
) async {
  final client = http.Client();

  final langFontsList = <LanguageFonts>[];
  final unrecognizedFontsList = <UnrecognizedFont>[];

  final langSubsetsMap = _langSubsetNameMapper;

  for (final langName in langSubsetsMap.keys) {
    langFontsList.add(LanguageFonts(langName: langName, fontNames: <String>[]));
  }

  await Future.forEach<String>(allFontNames, (fontName) async {
    final url = '$_baseUrl$fontName';

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'user-agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36'
        },
      );

      if (response.statusCode != 200) {
        throw ('${response.statusCode}: ${response.reasonPhrase}');
      }

      final responseContent = response.body;

      // Checks if the languages of the font are recognizable.
      langSubsetsMap.values.forEach((langSubset) {
        // Check whether it is possible to recognize the language(s) of the font
        // (see more in _unrecognizedSubsetTest method in generator_helper.dart).
        _unrecognizedLangSubsetTmpl().firstWhereOrNull(
          (unrecognizedLangSubset) {
            if (responseContent.contains(unrecognizedLangSubset)) {
              // If it is an unrecognized font, then throw an exception,
              // we can then determine which fonts must be error handled
              // from the errors.json file.
              throw ('font language(s) was/were not recognized');
            }
            return false;
          },
        );

        final langName = _getLangNameByValue(langSubset);

        if (responseContent.contains(_addSymbols(langSubset)) &&
            langName != null) {
          final index = langFontsList.indexWhere((e) => e.langName == langName);
          if (index != -1) langFontsList[index].fontNames.add(fontName);
        }
      });
    } catch (e) {
      // Checks failed API url calls and find out why, these errors will be saved in errors.txt.
      // If this font is already error handled then it is not written into errors.txt.
      final isAlreadyErrorHandled = errorHandledFonts.map((e) {
        if (e.fontNames.contains(fontName)) return true;
        return false;
      }).contains(true);

      if (!isAlreadyErrorHandled) {
        final errorMsg = e is http.Response
            ? '${e.statusCode.toString()}: ${e.reasonPhrase as String}'
            : e.toString();

        unrecognizedFontsList.add(UnrecognizedFont(
          fontName: fontName,
          errorPhrase: errorMsg,
        ));
        print(
          'font: \'$fontName\' was not successfully fetched ($errorMsg) - see errors.json',
        );
      }
    }
  });
  client.close();

  // Write unrecognized fonts to errors.json.
  _writeToJson(_errorFontsFilePath, unrecognizedFontsList);

  return langFontsList;
}

/// Tries to fetch [UnrecognizedFont] and match newly successful recognized to a list of [LanguageFonts].
Future<List<LanguageFonts>> _tryFetchUnrecognizedFontsLangs(
  List<UnrecognizedFont> unrecognizedFontsList,
) async {
  final client = http.Client();

  final langFontsList = <LanguageFonts>[];
  final recognizedFontsList = <Font>[];

  final langSubsetsMap = _langSubsetNameMapper;
  for (final langName in langSubsetsMap.keys) {
    langFontsList.add(LanguageFonts(langName: langName, fontNames: <String>[]));
  }

  try {
    final response = await client.get(Uri.parse(_baseUrlAlternative));

    if (response.statusCode != 200) {
      throw ('${response.statusCode}: ${response.reasonPhrase}');
    }

    final responseContent = response.body;
    final data = jsonDecode(responseContent);
    (data as List).forEach((element) {
      try {
        final recognizedFont = Font.fromJson(element);
        recognizedFontsList.add(recognizedFont);
      } catch (e) {
        print(e);
      }
    });

    // Matches newly recognized fetched fonts to its language subsets.
    langSubsetsMap.values.forEach((langSubset) {
      recognizedFontsList.forEach((recognizedFont) {
        final langName = _getLangNameByValue(langSubset);

        final recognizedFontName = recognizedFont.family;
        final recognizedFontSubsets = recognizedFont.langSubsets;

        final unrecognizedFontNamesList =
            unrecognizedFontsList.map((e) => e.fontName).toList();

        if (langName != null &&
            unrecognizedFontNamesList.isNotEmpty &&
            recognizedFontSubsets.isNotEmpty &&
            recognizedFontSubsets.contains(langSubset) &&
            unrecognizedFontNamesList.contains(recognizedFontName)) {
          final index = langFontsList.indexWhere((e) => e.langName == langName);
          if (index != -1) {
            langFontsList[index].fontNames.add(recognizedFontName);
          }
        }
      });
    });
  } catch (e) {
    final errorMsg = e is http.Response
        ? '${e.statusCode.toString()}: ${e.reasonPhrase as String}'
        : e.toString();
    print(errorMsg);
  }
  client.close();

  return langFontsList;
}

/// If [currLangName] is not null, then it will generate split file of base google_fonts.dart
/// of the [currLangName] language name.
///
/// Otherwise it generates the base google_fonts.dart file, which
/// is always generated after the splitting operation.
String _generateDartCode(
  pb.Directory fontDir,
  List<LanguageFonts> languageFontsList, {
  String? currLangName,
}) {
  // google_fonts.tmpl related
  final importNames = <Map<String, dynamic>>[];
  final mainMethods = <Map<String, dynamic>>[];

  // google_fonts_language.tmpl related
  final langClasses = <Map<String, dynamic>>[];
  const langClassNameKey = 'langClassName';
  const langMethodNameKey = 'langMethod';

  final fontsFamilyList = fontDir.family;

  for (final languageFonts in languageFontsList) {
    final langName = languageFonts.langName;

    importNames.add(<String, dynamic>{
      'fileName': _dashReplacement(_langSubsetNameMapper[langName]!),
    });

    if (langName == currLangName) {
      langClasses.add(<String, dynamic>{
        langClassNameKey: currLangName,
        langMethodNameKey: <Map<String, dynamic>>[],
      });
    }
  }

  for (final item in fontsFamilyList) {
    // this is a font name, e.g.: Lato, Droid Sans, ...
    final family = item.name;

    // do not create methods for the fonts that were not found in any language category
    final availableFontList = languageFontsList
        .map((e) => e.fontNames)
        .expand((element) => element)
        .toSet()
        .toList();
    if (!availableFontList.contains(family)) continue;

    final familyNoSpaces = family.replaceAll(' ', '');
    final familyWithPlusSigns = family.replaceAll(' ', '+');
    final methodName = _familyToMethodName(family);

    final method = <String, dynamic>{
      'methodName': methodName,
      'fontFamily': familyNoSpaces,
      'fontFamilyDisplay': family,
      'docsUrl': 'https://fonts.google.com/specimen/$familyWithPlusSigns',
      'fontUrls': [
        for (final variant in item.fonts)
          {
            'variantWeight': variant.weight.start,
            'variantStyle':
                variant.italic.start.round() == 1 ? 'italic' : 'normal',
            'hash': _hashToString(variant.file.hash),
            'length': variant.file.fileSize,
          },
      ],
      'themeParams': [
        for (final themeParam in _fontThemeParams) {'value': themeParam},
      ],
    };

    mainMethods.add(method);

    languageFontsList.forEach((element) {
      for (final langClass in langClasses) {
        try {
          final langKey = langClass[langClassNameKey] as String;

          if (langKey == element.langName && langKey == currLangName) {
            if (element.fontNames.contains(family)) {
              final currValueList =
                  langClass[langMethodNameKey] as List<Map<String, dynamic>>;
              langClass[langMethodNameKey] = currValueList..add(method);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  final template = Template(
    File(currLangName != null ? _langTemplatePath : _templatePath)
        .readAsStringSync(),
    htmlEscapeValues: false,
  );
  return template.renderString({
    'imports': importNames,
    'langClass': langClasses,
    'method': mainMethods,
  });
}

String _familyToMethodName(String family) {
  final words = family.split(' ');
  for (var i = 0; i < words.length; i++) {
    final word = words[i];
    final isFirst = i == 0;
    final isUpperCase = word == word.toUpperCase();
    words[i] = (isFirst ? word[0].toLowerCase() : word[0].toUpperCase()) +
        (isUpperCase ? word.substring(1).toLowerCase() : word.substring(1));
  }
  return words.join();
}
