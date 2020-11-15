part of 'generator.dart';

const _success = 'Success!';

const _generatedFilePath = 'lib/google_fonts.dart';
const _langFontsSubsetPath = 'generator/lang_font_subsets/';

const _baseUrl = 'https://fonts.googleapis.com/css2?family=';

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

const _langSubsetMapper = <String, String>{
  'Arabic': '/* arabic */',
  'Bengali': '/* bengali */',
  'Cyrillic': '/* cyrillic */',
  'CyrillicExt': '/* cyrillic-ext */',
  'Devanagari': '/* devanagari */',
  'Greek': '/* greek */',
  'GreekExt': '/* greek-ext */',
  'Gujarati': '/* gujarati */',
  'Gurmukhi': '/* gurmukhi */',
  'Hebrew': '/* hebrew */',
  'ChineseHK': '/* chinese-hongkong */',
  'ChineseSimpl': '/* chinese-simplified */',
  'ChineseTrad': '/* chinese-traditional */',
  'Japanese': '/* japanese */',
  'Kannada': '/* kannada */',
  'Khmer': '/* khmer */',
  'Korean': '/* korean */',
  'Latin': '/* latin */',
  'LatinExt': '/* latin-ext */',
  'Malayalam': '/* malayalam */',
  'Myanmar': '/* myanmar */',
  'Oriya': '/* oriya */',
  'Sinhala': '/* sinhala */',
  'Tamil': '/* tamil */',
  'Telugu': '/* telugu */',
  'Thai': '/* thai */',
  'Tibetan': '/* tibetan */',
  'Vietnamese': '/* vietnamese */',
};

/// Chinese & Japanese fonts display for some reason only numbers in API response ...
///
/// <br>
/// e.g. these fonts:
///
/// [Noto Serif SC](https://fonts.googleapis.com/css2?family=Noto+Serif+SC)
///
/// [Noto Sans JP](https://fonts.googleapis.com/css2?family=Noto+Sans+JP)
List<String> _unrecognizedSubsetTemplate() {
  final list = List<String>.generate(201, (index) => '/* [$index] */');
  return list;
}

// this is a temporary for testing purposes and has no use, will be moved to the test dir later
const _recognizedSubsetTest = '''
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: local('Roboto'), local('Roboto-Regular'), url(https://fonts.gstatic.com/s/roboto/v20/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format('woff2');
  unicode-range: U+0100-024F, U+0259, U+1E00-1EFF, U+2020, U+20A0-20AB, U+20AD-20CF, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: local('Roboto'), local('Roboto-Regular'), url(https://fonts.gstatic.com/s/roboto/v20/KFOmCnqEu92Fr1Mu4mxK.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
''';

// this is a temporary for testing purposes and has no use, will be moved to the test dir later
const _unrecognizedSubsetTest = '''
@font-face {
  font-family: 'Noto Sans JP';
  font-style: normal;
  font-weight: 400;
  src: local('Noto Sans Japanese Regular'), local('NotoSansJapanese-Regular'), url(https://fonts.gstatic.com/s/notosansjp/v28/-F62fjtqLzI2JPCgQBnw7HFow2oe2EcP5pp0erwTqsSWs9Jezazjcb4.61.woff2) format('woff2');
  unicode-range: U+a8, U+2032, U+2261, U+2282, U+3090, U+30f1, U+339c, U+535c, U+53d9, U+56a2, U+56c1, U+5806, U+589f, U+59d0, U+5a7f, U+60e0, U+639f, U+65af, U+68fa, U+69ae, U+6d1b, U+6ef2, U+71fb, U+725d, U+7262, U+75bc, U+7768, U+7940, U+79bf, U+7bed, U+7d68, U+7dfb, U+814b, U+8207, U+83e9, U+8494, U+8526, U+8568, U+85ea, U+86d9, U+87ba, U+8861, U+887f, U+8fe6, U+9059, U+9061, U+916a, U+976d, U+97ad, U+9ece;
}
/* [62] */
@font-face {
  font-family: 'Noto Sans JP';
  font-style: normal;
  font-weight: 400;
  src: local('Noto Sans Japanese Regular'), local('NotoSansJapanese-Regular'), url(https://fonts.gstatic.com/s/notosansjp/v28/-F62fjtqLzI2JPCgQBnw7HFow2oe2EcP5pp0erwTqsSWs9Jezazjcb4.62.woff2) format('woff2');
  unicode-range: U+2d9, U+21d4, U+301d, U+515c, U+52fe, U+5420, U+5750, U+5766, U+5954, U+5b95, U+5f8a, U+5f98, U+620c, U+621f, U+641c, U+66d9, U+676d, U+6775, U+67f5, U+694a, U+6a02, U+6a3a, U+6a80, U+6c23, U+6c72, U+6dcb, U+6faa, U+707c, U+71c8, U+7422, U+74e2, U+7791, U+7825, U+7a14, U+7a1c, U+7c95, U+7fc1, U+82a5, U+82db, U+8304, U+853d, U+8cd3, U+8de8, U+8f0c, U+8f3f, U+9091, U+91c7, U+929a, U+98af, U+9913;
}
/* [63] */
''';