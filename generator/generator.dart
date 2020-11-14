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

Future<void> main() async {
  // print(await _retrieveAllDirLangFiles());
  // print(resp.body);
}

/// Generates the `GoogleFonts` class.
Future<void> main2() async {
  print('Getting latest font directory...');
  final protoUrl = await _getProtoUrl();
  print('Success! Using $protoUrl');

  final fontDirectory = await _readFontsProtoData(protoUrl);
  print('\nValidating font URLs and file contents...');
  //await _verifyUrls(fontDirectory);
  print(_success);

  // TODO: add parameter to main method
  // by default should be false - it creates unnecessary long API calls
  if (true) {
    print('\nMatching compatible fonts with languages...');
    final List<String> availableFontNames = (fontDirectory.family).map((font) => font.name).toList();
    final Map<String, List<String>> matchedLangsWithFonts = await _matchLangsWithFonts(availableFontNames);
    print(_success);

    print('\nWriting font names to language files...');
    print(_success);
  } else {
    print('\nRetrieving font names to language files...');
    print(_success);
  }

  // print('\nGenerating $_generatedFilePath...');
  // await _writeDartFile(_generateDartCode(fontDirectory));
  // print(_success);
  //
  // print('\nFormatting $_generatedFilePath...');
  // await Process.run('flutter', ['format', _generatedFilePath]);
  // print(_success);
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

/// Creates a map where the **key** is a language name (Arabic, Latin, Cyrillic, ...) and
/// the **value** is a *List* of *String* which contains its compatible font names.
Future<Map<String, List<String>>> _matchLangsWithFonts(List<String> availableFontNames) async {
  final client = http.Client();

  final mapMatcher = _langSubsetMatcher;
  final languages = _langSubsetMatcher.keys.toList();
  final subsets = _langSubsetMatcher.values.toList();

  final langFontMap = <String, List<String>>{
    for (final langName in languages) langName: <String>[''],
  };

  await Future.forEach<String>(availableFontNames, (fontName) async {
    final url = '$_baseUrl$fontName';

    try {
      final response = await client.get(
        url,
        headers: {
          'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36'
        },
      );

      if (response.statusCode != 200) {
        throw ('Bad response from Google Fonts API.\n${response?.statusCode}:${response?.reasonPhrase}');
      }

      final content = response.body;
      subsets.forEach((subset) {
        if (content.contains(subset)) {
          final keyByValue = mapMatcher.keys.firstWhere(
            (key) => mapMatcher[key] == subset,
            orElse: () => null,
          );
          final currValueList = langFontMap[keyByValue];
          langFontMap[keyByValue] = currValueList..add(fontName);
        }
      });
    } catch (e) {
      print(e);

      // Check failed API url calls and find out why. Consider adding these failed fonts manually if the error shouldn't have occurred.
      if (langFontMap['errors'] == null) {
        langFontMap['errors'] = [''];
      }
      final currValueList = langFontMap['errors'];
      langFontMap['errors'] = currValueList..add(fontName);
    }
  });
  client.close();

  return langFontMap..removeWhere((key, value) => key == null || value == null || value.isEmpty);
}

Future<void> _writeAllLangsFontNamesToFiles() async {
  final langSubsetFiles = <File>[];

  final dir = Directory(_langFontsSubsetPath);
  final files = await dir.list().toList();

  for (final file in files) {
    if (file is File && p.extension(file.path) == '.txt') langSubsetFiles.add(file);
  }

  return langSubsetFiles;
}

Future<Map<String, List<String>>> _retrieveAllLangsFontNamesFromFiles() async {
  final List<File> langSubsetFiles = await _retrieveAllDirLangFiles();

  final dir = Directory(_langFontsSubsetPath);
  final files = await dir.list().toList();

  for (final file in files) {
    if (file is File && p.extension(file.path) == '.txt') {
      langSubsetFiles.add(file);
    }
  }

  return null;
}

Future<List<File>> _retrieveAllDirLangFiles() async {
  final langFiles = <File>[];

  final dir = Directory(_langFontsSubsetPath);
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

Future<void> _writeDartFile(String content) async {
  await File(_generatedFilePath).writeAsString(content);
}

String _generateDartCode(pb.Directory fontDirectory) {
  final classes = <Map<String, String>>[];
  final methods = <Map<String, dynamic>>[];

  final fonts = fontDirectory.family;

  // final subsetFilter = <String>{
  //   'Roboto',
  //   'Lato',
  //   'PT Mono',
  //   'Noto Sans',
  // };

  // if (fonts.isNotEmpty) {
  //   for (final lang in languages) {
  //     classes.add(<String, String>{
  //       'langClassName': lang,
  //     });
  //   }
  // }

  for (final item in fonts) {
    // font name, e.g.: Lato, Droid Sans, ...
    final family = item.name;

    // filter out fonts which are not latin extended
    // if (!langSubsets.entries.contains(family)) continue;

    final familyNoSpaces = family.replaceAll(' ', '');
    final familyWithPlusSigns = family.replaceAll(' ', '+');
    final methodName = _familyToMethodName(family);

    const themeParams = [
      'headline1',
      'headline2',
      'headline3',
      'headline4',
      'headline5',
      'headline6',
      'subtitle1',
      'subtitle2',
      'bodyText1',
      'bodyText2',
      'caption',
      'button',
      'overline',
    ];

    methods.add(<String, dynamic>{
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
        for (final themeParam in themeParams) {'value': themeParam},
      ],
    });
  }

  final template = Template(
    File('generator/google_fonts.tmpl').readAsStringSync(),
    htmlEscapeValues: false,
  );
  return template.renderString({
    'class': classes,
    'method': methods,
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
