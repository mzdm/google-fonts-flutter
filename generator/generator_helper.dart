part of 'generator.dart';

const _success = 'Success!';
const _urlSpaceChar = '%20';

const _generatedFilePath = 'lib/google_fonts.dart';
const _langFontsSubsetPath = 'generator/lang_font_subsets/';

const _baseUrl = 'https://fonts.googleapis.com/css2?family=';

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

/// Chinese & Japanese fonts display for some reason only numbers...
///
/// e.g. these fonts:
///
/// [Noto Serif SC](https://fonts.googleapis.com/css2?family=Noto+Serif+SC)
///
/// [Noto Sans JP](https://fonts.googleapis.com/css2?family=Noto+Sans+JP)
const _unrecognizedSubsets = <String>[
  '/* [0] */',
  '/* [1] */',
  '/* [2] */',
  '/* [4] */',
  '/* [5] */',
  '/* [6] */',
  '/* [21] */',
  '/* [25] */',
  '/* [31] */',
  '/* [38] */',
  '/* [40] */',
  '/* [66] */',
  '/* [71] */',
  '/* [77] */',
  '/* [117] */',
];