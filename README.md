[![pub package](https://img.shields.io/pub/v/google_language_fonts.svg)](https://pub.dev/packages/google_language_fonts) ![build](https://github.com/mzdm/google-language-fonts-flutter/actions/workflows/main.yml/badge.svg)

# google_language_fonts

A simple way to use compatible fonts with your languages, without worrying about unrecognized characters.

<p align="center">
<img style="zoom: 0.8" src="https://raw.githubusercontent.com/mzdm/google-language-fonts-flutter/master/readme_images/comparation.png" />
</p>

This unofficial [google_language_fonts](https://pub.dev/packages/google_language_fonts) package is an extension of the [google_fonts](https://pub.dev/packages/google_fonts) package and it allows you to easily use more than 950 fonts
(and their variants) from [fonts.google.com](https://fonts.google.com/) in your Flutter app.

These fonts are matched with the **27 languages** listed below so you can use them right away from your IDE.

To use it as a language font simply add `Fonts` suffix to any of these currently supported languages below

- e.g.: `LatinFonts`, `CyrillicFonts`, ...

| Prefix | | |
|-|-|-|
| [**Arabic**](https://en.wikipedia.org/wiki/Arabic_script_in_Unicode#Compact_table) | [Gurmukhi](https://en.wikipedia.org/wiki/Gurmukhi_(Unicode_block)) | [Malayalam](https://en.wikipedia.org/wiki/Malayalam_(Unicode_block)) |
| [Bengali](https://en.wikipedia.org/wiki/Bengali_(Unicode_block)) | [**Hebrew**](https://en.wikipedia.org/wiki/Hebrew_(Unicode_block)) | [Myanmar](https://en.wikipedia.org/wiki/Myanmar_(Unicode_block)) |
| [**Cyrillic**](https://en.wikipedia.org/wiki/Cyrillic_(Unicode_block)) | [**ChineseSimpl**](https://en.wikipedia.org/wiki/Simplified_Chinese_characters) * | [Oriya](https://en.wikipedia.org/wiki/Oriya_(Unicode_block)) |
| [CyrillicExt](https://en.wikipedia.org/wiki/Cyrillic_script#Unicode) | [**Japanese**](https://en.wikipedia.org/wiki/Japanese_writing_system) | [Sinhala](https://en.wikipedia.org/wiki/Sinhala_(Unicode_block)) |
| [Czech](https://unicode-table.com/en/alphabets/czech/) | [Kannada](https://en.wikipedia.org/wiki/Kannada_(Unicode_block)) | [Tamil](https://en.wikipedia.org/wiki/Tamil_(Unicode_block)) |
| [**Devanagari**](https://en.wikipedia.org/wiki/Devanagari_(Unicode_block)) | [Khmer](https://en.wikipedia.org/wiki/Khmer_(Unicode_block)) | [Telugu](https://en.wikipedia.org/wiki/Telugu_(Unicode_block)) |
| [**Greek**](https://en.wikipedia.org/wiki/Greek_and_Coptic) | [**Korean**](https://en.wikipedia.org/wiki/Korean_language#Writing_system) | [**Thai**](https://en.wikipedia.org/wiki/Thai_(Unicode_block)) |
| [GreekExt](https://en.wikipedia.org/wiki/Greek_Extended) | [**Latin**](https://en.wikipedia.org/wiki/Basic_Latin_(Unicode_block)) \** | [Tibetan](https://en.wikipedia.org/wiki/Tibetan_(Unicode_block)) |
| [Gujarati](https://en.wikipedia.org/wiki/Gujarati_(Unicode_block)) | [LatinExt](https://en.wikipedia.org/wiki/Latin_Extended-A#Compact_table) | [**Vietnamese**](https://en.wikipedia.org/wiki/Vietnamese_language_and_computers#Fonts_and_character_encodings) |

\* Chinese Simplified

\** This language subset contains almost all fonts (same as base GoogleFonts)

## Getting Started

With the `google_language_fonts` package, `.ttf` or `.otf` files do not need to be stored in your assets folder and mapped in
the pubspec. Instead, they can be fetched once via http at runtime, and cached in the app's file system. This is ideal for development, and can be the preferred behavior for production apps that
are looking to reduce the app bundle size. Still, you may at any time choose to include the font file in the assets, and the Google Fonts package will prioritize pre-bundled files over http fetching.
Because of this, the Google Fonts package allows developers to choose between pre-bundling the fonts and loading them over http, while using the same API.

For example, say you want to use any of the [Cyrillic](https://fonts.google.com/?sort=popularity&subset=cyrillic) fonts from Google Fonts in your Flutter app. You would need to try one by one until you find what satisfies your needs. With this package, you can try your fonts right away from IDE thanks to auto-suggestions.

First, add the `google_language_fonts` package to your [pubspec dependencies](https://pub.dev/packages/google_language_fonts#-installing-tab-).

To import any of the `LanguageFonts`, for example `LatinFonts`:

```dart
import 'package:google_language_fonts/google_language_fonts.dart';
```

To use for example `LatinFonts` with the default TextStyle:

```dart
Text(
  'This is Google Fonts',
  style: LatinFonts.playfairDisplay(),
),
```

Or, if you want to load the font dynamically:

```dart
Text(
  'This is Google Fonts',
  style: GoogleFonts.getFont('Lato'),
),
```

To use `GoogleFonts` with an existing `TextStyle`:

```dart
Text(
  'This is Google Fonts',
  style: CyrillicFonts.robotoCondensed(
    textStyle: TextStyle(color: Colors.blue, letterSpacing: .5),
  ),
),
```

or

```dart
Text(
  'This is Google Fonts',
  style: CyrillicFonts.robotoCondensed(textStyle: Theme.of(context).textTheme.display1),
),
```

To override the `fontSize`, `fontWeight`, or `fontStyle`:

```dart
Text(
  'This is Google Fonts',
  style: LatinFonts.playfairDisplay(
    textStyle: Theme.of(context).textTheme.display1,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
  ),
),
```

You can also use for example `CyrillicFonts.robotoCondensedTextTheme()` to make or modify an entire text theme to use the "robotoCondensedTextTheme" font.

```dart
MaterialApp(
  theme: ThemeData(
    textTheme: CyrillicFonts.robotoCondensedTextTheme(
      Theme.of(context).textTheme,
    ),
  ),
);
```

Or, if you want a `TextTheme` where a couple of styles should use a different font:

```dart
final textTheme = Theme.of(context).textTheme;

MaterialApp(
  theme: ThemeData(
    textTheme: CyrillicFonts.robotoCondensedTextTheme(textTheme).copyWith(
      body1: ArabicFonts.mada(textStyle: textTheme.body1),
    ),
  ),
);
```

### Bundling font files in your application's assets

The `google_language_fonts` package will automatically use matching font files in your `pubspec.yaml`'s
`assets` (rather than fetching them at runtime via HTTP). Once you've settled on the fonts
you want to use:

1. Download the font files from [https://fonts.google.com](https://fonts.google.com).
You only need to download the weights and styles you are using for any given family.
Italic styles will include `Italic` in the filename. Font weights map to file names as follows:

```dart
{
  FontWeight.w100: 'Thin',
  FontWeight.w200: 'ExtraLight',
  FontWeight.w300: 'Light',
  FontWeight.w400: 'Regular',
  FontWeight.w500: 'Medium',
  FontWeight.w600: 'SemiBold',
  FontWeight.w700: 'Bold',
  FontWeight.w800: 'ExtraBold',
  FontWeight.w900: 'Black',
}
```

2. Move those fonts to a top-level app directory (e.g. `google_fonts`).

![](https://raw.githubusercontent.com/material-foundation/google-fonts-flutter/master/readme_images/google_fonts_folder.png)

3. Ensure that you have listed the folder (e.g. `google_fonts/`) in your `pubspec.yaml` under `assets`.

![](https://raw.githubusercontent.com/material-foundation/google-fonts-flutter/master/readme_images/google_fonts_pubspec_assets.png)

Note: Since these files are listed as assets, there is no need to list them in the `fonts` section
of the `pubspec.yaml`. This can be done because the files are consistently named from the Google Fonts API
(so be sure not to rename them!)

### Compatibility
In this package calling fonts from the GoogleFonts class is not possible due to having faster IDE auto-suggestions and to not clash with the official package. However, this package is compatible with the official [google_fonts](https://pub.dev/packages/google_fonts) package. If you want to access **any font** without having to be limited to a language then you can either:
- just use` LatinFonts` prefix, which contains almost all fonts from the base `GoogleFonts`, e.g.: `LatinFonts.lato()`,
- or call a font dynamically: `GoogleFonts.getFont('Lato')`,
	```
	// you can not access e.g.: GoogleFonts.lato(), only dynamically via GoogleFonts.getFont('Lato')
	import 'package:google_language_fonts/google_language_fonts.dart';
    ```
- or add official [google_fonts](https://pub.dev/packages/google_fonts) package and use GoogleFonts in this way:
	```
	// only if you add google_fonts package then you can access it with 'as' keyword like:
	import 'package:google_fonts/google_fonts.dart' as basic; // basic.GoogleFonts.lato()
	```

### Licensing Fonts
The fonts on [fonts.google.com](https://fonts.google.com/) include license files for each font. For
example, the [Lato](https://fonts.google.com/specimen/Lato) font comes with an `OFL.txt` file.

Once you've decided on the fonts you want in your published app, you should download and add the appropriate
licenses to your flutter app's [LicenseRegistry](https://api.flutter.dev/flutter/foundation/LicenseRegistry-class.html).

For example:
```dart
void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  
  runApp(...);
}
```
