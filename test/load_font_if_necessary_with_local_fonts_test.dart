import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_language_fonts/src/google_fonts_base.dart';
import 'package:google_language_fonts/src/google_fonts_descriptor.dart';
import 'package:google_language_fonts/src/google_fonts_family_with_variant.dart';
import 'package:google_language_fonts/src/google_fonts_variant.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_font_if_necessary_with_local_fonts_test.mocks.dart';

const _fakeResponse = 'fake response body - success';
// The number of bytes in _fakeResponse.
const _fakeResponseLengthInBytes = 28;
// Computed by converting _fakeResponse to bytes and getting sha 256 hash.
const _fakeResponseHash =
    '1194f6ffe4d2f05258573616a77932c38041f3102763096c19437c3db1818a04';
final _fakeResponseFile = GoogleFontsFile(
  _fakeResponseHash,
  _fakeResponseLengthInBytes,
);

// =============================== WARNING! ====================================
// Do not add tests to this test file. Because the set up mocks a system message
// handler (flutter/assets), that can not be undone, no other tests should be
// written in this file.
//
// NOTE: Test in this file can only run on macOS for now!
@GenerateMocks([http.Client])
void main() {
  late MockClient httpClient;
  setUp(() async {
    httpClient = MockClient();
    GoogleFonts.config.allowRuntimeFetching = true;
    when(httpClient.get(any)).thenAnswer((_) async {
      return http.Response(_fakeResponse, 200);
    });

    // Add Foo-BlackItalic to mock asset bundle.
    ServicesBinding.instance!.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (dynamic message) {
      final encoded =
          utf8.encoder.convert('{"google_fonts/Foo-BlackItalic.ttf":'
              '["google_fonts/Foo-BlackItalic.ttf"]}');
      return Future.value(encoded.buffer.asByteData());
    });

    // The following snippet pulled from
    //  * https://flutter.dev/docs/cookbook/persistence/reading-writing-files#testing
    final directory = await Directory.systemTemp.createTemp();
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((methodCall) async {
      if (methodCall.method == 'getApplicationSupportDirectory') {
        return directory.path;
      }
      return null;
    });
  });

  testWidgets(
      'loadFontIfNecessary method does nothing if the font is in the '
      'Asset Manifest', (tester) async {
    final descriptorInAssets = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
        family: 'Foo',
        googleFontsVariant: GoogleFontsVariant(
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
        ),
      ),
      file: _fakeResponseFile,
    );

    // Call loadFontIfNecessary and verify no http request happens because
    // Foo-BlackItalic is in the asset bundle.
    await loadFontIfNecessary(descriptorInAssets);
    verifyNever(httpClient.get(any));

    final descriptorNotInAssets = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
        family: 'Bar',
        googleFontsVariant: GoogleFontsVariant(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ),
      file: _fakeResponseFile,
    );

    // Call loadFontIfNecessary and verify that an http request happens because
    // Bar-BoldItalic is not in the asset bundle.
    await loadFontIfNecessary(descriptorNotInAssets);
    verify(httpClient.get(any)).called(1);
  });
}
