part of 'generator.dart';

/// Message displayed in console when doing any generator command.
const _successMessage = 'Success!';

/// File path of the template to generate the content of the base [GoogleFonts] class.
const _templatePath = 'generator/google_fonts.tmpl';

/// File path of the template to generate the content of the split [LanguageFonts] class.
const _langTemplatePath = 'generator/google_fonts_language.tmpl';

/// File path of the base [GoogleFonts] class.
const _generatedFilePath = 'lib/src/fonts/google_fonts.dart';

/// Used for generating split lang classes of [GoogleFonts].
String _getGeneratedLangFilePath(String langName) =>
    'lib/src/fonts/google_fonts_${_dashReplacement(_langSubsetNameMapper[langName]!)}.dart';

/// Will replace all dashes with underscore, used for generating lang classes of GoogleFonts.
String _dashReplacement(String str) => str.replaceAll('-', '_');

/// File path of Czech fonts.
const _langFontsSubsetFolderPath = 'generator/lang_font_subsets/';

/// File path of fonts which were recognized during checking Google Fonts API.
const _langFontsFilePath = '${_langFontsSubsetFolderPath}fonts.json';
const _czechFontsFilePath = '${_langFontsSubsetFolderPath}czech_fonts.json';

/// File path of error fonts which were successfully recognized during checking
/// from alternative fonts API.
const _errorHandledLangFontsFilePath =
    '${_langFontsSubsetFolderPath}error_handled_fonts.json';

/// File path of fonts which were not recognized during checking Google Fonts API ([_baseUrl]).
const _errorFontsFilePath = '${_langFontsSubsetFolderPath}errors.json';

/// Base official Google Fonts API.
const _baseUrl = 'https://fonts.googleapis.com/css2?family=';

/// Alternative API which is used for checking fonts from errors.json.
const _baseUrlAlternative =
    'https://google-webfonts-helper.herokuapp.com/api/fonts';

const _fontThemeParams = [
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

/// A key-value map where key is a language name and by value for checking Google Fonts API
/// response whether the font supports this language subset. Also value is used for file name
/// of GoogleFonts class (unformatted), formatting is done by [_dashReplacement] method.
const _langSubsetNameMapper = <String, String>{
  'Arabic': 'arabic',
  'Bengali': 'bengali',
  'ChineseHK': 'chinese-hongkong',
  'ChineseSimpl': 'chinese-simplified',
  'ChineseTrad': 'chinese-traditional',
  'Cyrillic': 'cyrillic',
  'CyrillicExt': 'cyrillic-ext',
  'Czech': 'czech',
  'Devanagari': 'devanagari',
  'Greek': 'greek',
  'GreekExt': 'greek-ext',
  'Gujarati': 'gujarati',
  'Gurmukhi': 'gurmukhi',
  'Hebrew': 'hebrew',
  'Japanese': 'japanese',
  'Kannada': 'kannada',
  'Khmer': 'khmer',
  'Korean': 'korean',
  'Latin': 'latin',
  'LatinExt': 'latin-ext',
  'Malayalam': 'malayalam',
  'Myanmar': 'myanmar',
  'Oriya': 'oriya',
  'Sinhala': 'sinhala',
  'Tamil': 'tamil',
  'Telugu': 'telugu',
  'Thai': 'thai',
  'Tibetan': 'tibetan',
  'Vietnamese': 'vietnamese',
};

/// This adds `/*` and `*/` symbols to [str] String value.
///
/// Used in fetching from Google Fonts API where language subsets are listed
/// with these symbols.
String _addSymbols(String str) => '/* $str */';

/// Gets a key (lang name) from [_langSubsetNameMapper] by [value].
String? _getLangNameByValue(String value) =>
    _langSubsetNameMapper.keys.firstWhereOrNull(
      (k) => _langSubsetNameMapper[k] == value,
    );

/// Chinese & Japanese fonts in the API response are displayed for some reason
/// only with numbers ...
///
/// This method returns of numbers to check API response whether it contains
/// such fonts.
///
/// e.g. these fonts:
///
/// [Noto Serif SC](https://fonts.googleapis.com/css2?family=Noto+Serif+SC)
/// [Noto Sans JP](https://fonts.googleapis.com/css2?family=Noto+Sans+JP)
List<String> _unrecognizedLangSubsetTmpl() {
  final list = List<String>.generate(201, (index) => '/* [$index] */');
  return list;
}

/// This method concatenates all lists of [LanguageFonts] to one list and sorted
/// alphabetically ASC.
List<LanguageFonts> _concatenateLanguageFonts(List<List<LanguageFonts>> args) {
  final concatenatedList = <LanguageFonts>[];

  for (final langName in _langSubsetNameMapper.keys) {
    concatenatedList.add(
      LanguageFonts(langName: langName, fontNames: <String>[]),
    );
  }

  args.forEach((list) {
    for (final element in list) {
      final langName = element.langName;
      final fontNames = element.fontNames;

      final index = concatenatedList.indexWhere((e) => e.langName == langName);
      if (index != -1) {
        concatenatedList[index].fontNames.addAll(fontNames);

        final unique = concatenatedList[index].fontNames.map((e) => e).toSet();
        concatenatedList[index].fontNames
          ..retainWhere((element) => unique.remove(element))
          ..sort();
      }
    }
  });
  return concatenatedList;
}
