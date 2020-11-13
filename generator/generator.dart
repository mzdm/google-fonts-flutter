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

const _generatedFilePath = 'lib/google_fonts.dart';
const _langFontSubsetsPath = 'generator/lang_font_subsets/';

// Future<void> main() async {
//   print(await _matchLanguagesWithFonts());
// }

/// Generates the `GoogleFonts` class.
Future<void> main() async {
  print('Getting latest font directory...');
  final protoUrl = await _getProtoUrl();
  print('Success! Using $protoUrl');

  final fontDirectory = await _readFontsProtoData(protoUrl);
  print('\nValidating font URLs and file contents...');
  await _verifyUrls(fontDirectory);
  print(_success);

  print('\nRetrieving the language subsets with font names...');
  final subset = await _matchLanguagesWithFonts();
  print(_success);

  print('\nGenerating $_generatedFilePath...');
  await _writeDartFile(_generateDartCode(fontDirectory, subset));
  print(_success);

  print('\nFormatting $_generatedFilePath...');
  await Process.run('flutter', ['format', _generatedFilePath]);
  print(_success);
}

const _success = 'Success!';

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

/// Creates a map where the **key** is a language name (Arabic, Latin, Chinese, Cyrillic, ...) and
/// the **value** is a *List* of *String* which contains compatible font names with its language.
Future<Map<String, List<String>>> _matchLanguagesWithFonts() async {
  final List<String> languages = await _retrieveAllLanguageFontSubsetsNames();

  final langValues = <String, List<String>>{
    for (final lang in languages)
      lang: _retrieveLanguageFontsFromFile(lang)
  };
  return langValues;
}

Future<List<String>> _retrieveAllLanguageFontSubsetsNames() async {
  final langSubsetFiles = <File>[];

  final dir = Directory(_langFontSubsetsPath);
  final files = await dir.list().toList();

  for (final file in files) {
    if (file is File && p.extension(file.path) == '.txt') langSubsetFiles.add(file);
  }

  final List<String> languages = List<String>.of(langSubsetFiles.map((file) {
    return p.basenameWithoutExtension(file.path);
  }));
  return languages;
}

List<String> _retrieveLanguageFontsFromFile(String languageName) {
  final listOfFonts = File('generator/lang_font_subsets/$languageName.txt').readAsLinesSync();
  return listOfFonts;
}

Future<void> _writeDartFile(String content) async {
  await File(_generatedFilePath).writeAsString(content);
}

String _generateDartCode(
  pb.Directory fontDirectory,
  Map<String, List<String>> subsetFilter,
) {
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

    // filter out fonts which are not latin extented
    if (!subsetFilter.entries.contains(family)) continue;

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

Future<pb.Directory> _readFontsProtoData(String protoUrl) async {
  final fontsProtoFile = await http.get(protoUrl);
  return pb.Directory.fromBuffer(fontsProtoFile.bodyBytes);
}
