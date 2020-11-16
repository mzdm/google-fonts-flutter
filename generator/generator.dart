// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:console/console.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mustache/mustache.dart';

import 'fonts.pb.dart' as pb;

part 'generator_helper.dart';

/// Generates the `GoogleFonts` private class and public `LanguageFont` classes.
///
/// If [args] contains `--fetch-langs` param then each font is checked via Google Fonts API
/// and written to its language file.
///
/// Keep in mind that if the database with fonts in step 1 is updated then these fonts
/// will not be mapped with languages and for that case is required to run the param above.
/// These fonts will be available only in `GoogleFonts` private class though.
Future<void> main(List<String> args) async {
  print('Getting latest font directory...');
  final protoUrl = await _getProtoUrl();
  print('Success! Using $protoUrl');

  final fontDirectory = await _readFontsProtoData(protoUrl);
  print('\nValidating font URLs and file contents...');
  await _verifyUrls(fontDirectory);
  print(_success);

  Map<String, List<String>> mappedLangFonts;
  Map<String, List<String>> mappedErrorHandledFonts;

  print('\nReading and mapping error handled fonts...');
  mappedErrorHandledFonts = await _retrieveAllLangsFontNamesFromFiles(
      _langMappedErrorFontsSubsetPath);
  print(_success);

  if (args.contains('--fetch-langs')) {
    print('\nFetching fonts and matching them with the languages...');
    final List<String> availableFontNames =
        (fontDirectory.family).map((font) => font.name).toList();
    mappedLangFonts = await _mapLangsWithFonts(
      _concatenateListStringMap(mappedErrorHandledFonts),
      availableFontNames,
    );
    print(_success);

    print('\nWriting font names to language files...');
    _writeAllLangsFontNamesToFiles(mappedLangFonts);
    print(_success);
  } else {
    print('\nRetrieving and mapping font names from the language files...');
    mappedLangFonts =
        await _retrieveAllLangsFontNamesFromFiles(_langFontsSubsetPath);
    print(_success);
  }

  print('\nConcatenating language fonts and error handled fonts...');
  mappedLangFonts = _concatenateFontsWithErrorHandled(
      mappedLangFonts, mappedErrorHandledFonts);
  print(_success);

  print('\nGenerating $_generatedFilePath...');
  await _writeDartFile(_generateDartCode(fontDirectory, mappedLangFonts));
  print(_success);

  print('\nFormatting $_generatedFilePath...');
  await Process.run('flutter', ['format', _generatedFilePath]);
  print(_success);
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
    final response = await httpClient.get(url(directoryVersion));
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
    final fileContents = await client.get(url);
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
  final fontsProtoFile = await http.get(protoUrl);
  return pb.Directory.fromBuffer(fontsProtoFile.bodyBytes);
}

/// TODO: Refactor
///
/// Creates a map where the **key** is a language name (Arabic, Latin, Cyrillic, ...) and
/// the **value** is a List of Strings which contains its compatible font names.
Future<Map<String, List<String>>> _mapLangsWithFonts(
  List<String> allMappedErrorFonts,
  List<String> availableFontNames,
) async {
  final client = http.Client();

  final mapMatcher = _langSubsetMapper;
  final languages = _langSubsetMapper.keys.toList();
  final subsets = _langSubsetMapper.values.toList();

  final langFontMap = <String, List<String>>{
    for (final langName in languages) langName: <String>[],
  };

  await Future.forEach<String>(availableFontNames, (fontName) async {
    final url = '$_baseUrl$fontName';

    try {
      final response = await client.get(
        url,
        headers: {
          'user-agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36'
        },
      );

      if (response.statusCode != 200) {
        throw ('${response?.statusCode}: ${response?.reasonPhrase}');
      }

      final unrecognizedLangsTemplate = _unrecognizedSubsetTemplate();
      final content = response.body;

      subsets.forEach((subset) {
        // Check whether it is possible to recognize the languages of the font
        // (see more in _unrecognizedSubsetTest method in generator_helper.dart).
        final recognizeResult = unrecognizedLangsTemplate.firstWhere(
          (element) => content.contains(element),
          orElse: () => 'recognized',
        );

        // Unrecognized fonts in the response doesn't mean that all of the fonts are unrecognized,
        // there might be some recognized so firstly add them. (?? needs confirmation, latest
        // font batch does not have such case.
        if (content.contains(subset)) {
          final keyByValue = mapMatcher.keys.firstWhere(
            (key) => mapMatcher[key] == subset,
            orElse: () => null,
          );
          final currValueList = langFontMap[keyByValue];
          langFontMap[keyByValue] = currValueList..add(fontName);
        }

        // If there was unrecognized font, then throw an exception
        // we can determine which fonts must be added manually.
        if (recognizeResult != 'recognized') {
          throw ('font language(s) was/were not recognized');
        }
      });
    } catch (e) {
      // Check failed API url calls and find out why, these errors will be stored in errors.txt.
      // If this font is already error handled (font manually added in error_handled_fonts dir) then
      // it is not written into errors.txt.
      if (!allMappedErrorFonts.contains(fontName)) {
        final errorMsg = e is http.Response
            ? e.statusCode.toString() + ': ' + e.reasonPhrase
            : e.toString();

        if (langFontMap[_errorFileKey] == null) {
          langFontMap[_errorFileKey] = <String>[];
        }

        final currValueList = langFontMap[_errorFileKey];
        langFontMap[_errorFileKey] = currValueList
          ..add('$fontName ($errorMsg)');

        print(
            'font: \'$fontName\' was not fetched ($errorMsg) - see errors.txt');
      }
    }
  });
  client.close();

  return langFontMap;
}

Future<List<File>> _listAllDirLangFiles(String path) async {
  final langFiles = <File>[];

  final dir = Directory(path);
  final allFiles = await dir.list().toList();

  for (final file in allFiles) {
    final path = file.path;
    if (file is File &&
        p.basenameWithoutExtension(path) != 'errors' &&
        p.extension(path) == '.txt') {
      langFiles.add(file);
    }
  }

  return langFiles;
}

void _writeAllLangsFontNamesToFiles(Map<String, List<String>> mappedLangs) {
  for (final lang in mappedLangs.keys) {
    final List<String> fonts = mappedLangs[lang];
    final formatted = fonts.join('\n');

    File('$_langFontsSubsetPath$lang.txt').writeAsStringSync(formatted);
  }
}

Future<Map<String, List<String>>> _retrieveAllLangsFontNamesFromFiles(
    String path) async {
  final List<File> langFiles = await _listAllDirLangFiles(path);

  final retrievedMap = <String, List<String>>{};
  for (final file in langFiles) {
    try {
      final langName = p.basenameWithoutExtension(file.path);
      final List<String> fontList = file.readAsLinesSync();
      retrievedMap[langName] = fontList;
    } catch (e) {
      print(
          'threw an error while reading from the file: ${p.basename(file.path)}');
    }
  }

  return retrievedMap;
}

Map<String, List<String>> _concatenateFontsWithErrorHandled(
  Map<String, List<String>> mappedLangFonts,
  Map<String, List<String>> mappedErrorHandledFonts,
) {
  for (final key in mappedErrorHandledFonts.keys) {
    if (key != null && mappedLangFonts[key] != null) {
      mappedLangFonts.update(key, (fontList) {
        final List<String> concatenatedList =
            fontList + mappedErrorHandledFonts[key];
        return concatenatedList.toSet().toList()..sort();
      });
    }
  }
  return mappedLangFonts;
}

Future<void> _writeDartFile(String content) async {
  await File(_generatedFilePath).writeAsString(content);
}

String _generateDartCode(
  pb.Directory fontDirectory,
  Map<String, List<String>> mappedLangs,
) {
  final mainMethods = <Map<String, dynamic>>[];
  final langClasses = <Map<String, dynamic>>[];

  final fonts = fontDirectory.family;

  final availableLangs = <String>[];

  const langClassNameKey = 'langClassName';
  const langMethodKey = 'langMethod';
  for (final langNameKey in mappedLangs.keys) {
    if (langNameKey != null) {
      availableLangs.add(langNameKey);
      langClasses.add(<String, dynamic>{
        langClassNameKey: langNameKey,
        langMethodKey: <Map<String, dynamic>>[],
      });
    }
  }

  for (final item in fonts) {
    // this is a font name, e.g.: Lato, Droid Sans, ...
    final family = item.name;

    // do not create methods for the fonts that were not found in any language category
    if (!mappedLangs.values.join(',').toString().contains(family)) continue;

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

    availableLangs.forEach((lang) {
      for (final langClass in langClasses) {
        try {
          final langKey = langClass[langClassNameKey] as String;
          if (langKey == lang) {
            if (mappedLangs[langKey].contains(family)) {
              final currValueList =
                  langClass[langMethodKey] as List<Map<String, dynamic>>;
              langClass[langMethodKey] = currValueList..add(method);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  final template = Template(
    File('generator/google_fonts.tmpl').readAsStringSync(),
    htmlEscapeValues: false,
  );
  return template.renderString({
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
