//@dart=2.9

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_language_fonts/src/asset_manifest.dart';
import 'package:google_language_fonts/src/google_fonts_base.dart';
import 'package:google_language_fonts/src/google_fonts_descriptor.dart';
import 'package:google_language_fonts/src/google_fonts_family_with_variant.dart';
import 'package:google_language_fonts/src/google_fonts_variant.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import 'load_font_if_necessary_test.mocks.dart';

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

var printLog = <String>[];

void overridePrint(Future<Null> Function() testFn) => () {
      var spec = ZoneSpecification(print: (_, __, ___, msg) {
        // Add to log instead of printing to stdout
        printLog.add(msg);
      });
      return Zone.current.fork(specification: spec).run(testFn);
    };

// NOTE: Some tests in this file can only run on macOS for now!
@GenerateMocks(
  [],
  customMocks: [
    MockSpec<http.Client>(),
    MockSpec<AssetManifest>(returnNullOnMissingStub: true),
  ],
)
void main() {
  final mockHttpClient = MockClient();
  setUp(() async {
    assetManifest = MockAssetManifest();
    GoogleFonts.config.allowRuntimeFetching = true;
    when(mockHttpClient.get(any)).thenAnswer((_) async {
      return http.Response(_fakeResponse, 200);
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

  tearDown(() {
    printLog.clear();
    clearCache();
  });

  testWidgets('loadFontIfNecessary method calls http get', (tester) async {
    final fakeDescriptor = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
          family: 'Foo',
          googleFontsVariant: GoogleFontsVariant(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          )),
      file: _fakeResponseFile,
    );

    await loadFontIfNecessary(fakeDescriptor);

    verify(mockHttpClient.get(any)).called(1);
  });

  testWidgets('loadFontIfNecessary method throws if font cannot be loaded',
      (tester) async {
    // Mock a bad response.
    when(mockHttpClient.get(any)).thenAnswer((_) async {
      return http.Response('fake response body - failure', 300);
    });

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

    // Call loadFontIfNecessary and verify that it prints an error.
    overridePrint(() async {
      await loadFontIfNecessary(descriptorInAssets);
      expect(printLog.length, 1);
      expect(
        printLog[0],
        startsWith(
            'google_language_fonts was unable to load font Foo-BlackItalic'),
      );
    });
  });

  testWidgets('does not call http if config is false', (tester) async {
    final fakeDescriptor = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
        family: 'Foo',
        googleFontsVariant: GoogleFontsVariant(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      file: _fakeResponseFile,
    );

    GoogleFonts.config.allowRuntimeFetching = false;

    // Call loadFontIfNecessary and verify that it prints an error.
    overridePrint(() async {
      await loadFontIfNecessary(fakeDescriptor);
      expect(printLog.length, 1);
      expect(
        printLog[0],
        startsWith('google_language_fonts was unable to load font Foo-Regular'),
      );
      expect(
        printLog[0],
        endsWith(
          "Ensure Foo-Regular.otf exists in a folder that is included in your pubspec's assets.",
        ),
      );
    });

    verifyNever(mockHttpClient.get(any));
  });

  testWidgets(
      'loadFontIfNecessary method does not make http get request on '
      'subsequent calls', (tester) async {
    final fakeDescriptor = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
        family: 'Foo',
        googleFontsVariant: GoogleFontsVariant(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      file: _fakeResponseFile,
    );

    // 1st call.
    await loadFontIfNecessary(fakeDescriptor);
    verify(mockHttpClient.get(any)).called(1);

    // 2nd call.
    await loadFontIfNecessary(fakeDescriptor);
    verifyNever(mockHttpClient.get(any));

    // 3rd call.
    await loadFontIfNecessary(fakeDescriptor);
    verifyNever(mockHttpClient.get(any));
  });

  testWidgets(
      'loadFontIfNecessary does not make more than 1 http get request on '
      'parallel calls', (tester) async {
    final fakeDescriptor = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
        family: 'Foo',
        googleFontsVariant: GoogleFontsVariant(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      file: _fakeResponseFile,
    );

    await Future.wait([
      loadFontIfNecessary(fakeDescriptor),
      loadFontIfNecessary(fakeDescriptor),
      loadFontIfNecessary(fakeDescriptor)
    ]);
    verify(mockHttpClient.get(any)).called(1);
  });

  testWidgets(
      'loadFontIfNecessary makes second attempt if the first attempt failed ',
      (tester) async {
    final fakeDescriptor = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
        family: 'Foo',
        googleFontsVariant: GoogleFontsVariant(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      file: _fakeResponseFile,
    );

    // Have the first call throw an error.
    when(mockHttpClient.get(any)).thenThrow('error');
    await loadFontIfNecessary(fakeDescriptor);
    verify(mockHttpClient.get(any)).called(1);

    // The second call will retry the http fetch.
    when(mockHttpClient.get(any)).thenAnswer((_) async {
      return http.Response(_fakeResponse, 200);
    });
    await loadFontIfNecessary(fakeDescriptor);
    verify(mockHttpClient.get(any)).called(1);
  });

  testWidgets('loadFontIfNecessary method writes font file', (tester) async {
    final fakeDescriptor = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
          family: 'Foo',
          googleFontsVariant: GoogleFontsVariant(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          )),
      file: _fakeResponseFile,
    );

    var directoryContents = await getApplicationSupportDirectory();
    expect(directoryContents.listSync().isEmpty, isTrue);

    await loadFontIfNecessary(fakeDescriptor);
    directoryContents = await getApplicationSupportDirectory();

    expect(directoryContents.listSync().isNotEmpty, isTrue);
    expect(
      directoryContents.listSync().single.toString().contains('Foo'),
      isTrue,
    );
  });

  testWidgets(
      'loadFontIfNecessary does not save anything to disk if the file does not '
      'match the expected hash', (tester) async {
    when(mockHttpClient.get(any)).thenAnswer((_) async {
      return http.Response('malicious intercepted response', 200);
    });
    final fakeDescriptor = GoogleFontsDescriptor(
      familyWithVariant: GoogleFontsFamilyWithVariant(
        family: 'Foo',
        googleFontsVariant: GoogleFontsVariant(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      file: _fakeResponseFile,
    );

    var directoryContents = await getApplicationSupportDirectory();
    expect(directoryContents.listSync().isEmpty, isTrue);

    await loadFontIfNecessary(fakeDescriptor);
    directoryContents = await getApplicationSupportDirectory();
    expect(directoryContents.listSync().isEmpty, isTrue);
  });

  test('loadFontByteData doesn\'t fail', () {
    expect(
      () async => loadFontByteData('fontFamily', Future.value(ByteData(0))),
      returnsNormally,
    );
    expect(
      () async => loadFontByteData('fontFamily', Future.value(null)),
      returnsNormally,
    );
    expect(
      () async => loadFontByteData('fontFamily', null),
      returnsNormally,
    );

    expect(
      () async => loadFontByteData('fontFamily',
          Future.delayed(Duration(milliseconds: 100), () => null)),
      returnsNormally,
    );
  });
}
