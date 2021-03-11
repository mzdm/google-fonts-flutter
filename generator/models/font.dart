/// Used for fetching from [google-webfonts-helper](https://google-webfonts-helper.herokuapp.com/).
class Font {
  final String family;
  final List<String> langSubsets;

  const Font({
    required this.family,
    required this.langSubsets,
  });

  factory Font.fromJson(Map<String, dynamic> json) => Font(
        family: json['family'],
        langSubsets: json['langSubsets']?.cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'family': family,
        'langSubsets': langSubsets,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Font &&
          runtimeType == other.runtimeType &&
          family == other.family &&
          langSubsets == other.langSubsets;

  @override
  int get hashCode => family.hashCode ^ langSubsets.hashCode;
}

/// This model class is used in errors.json file and contains font names and
/// error phrases of unrecognized fonts while fetching from official Google Fonts API.
class UnrecognizedFont {
  final String fontName;
  final String? errorPhrase;

  const UnrecognizedFont({
    required this.fontName,
    this.errorPhrase,
  });

  factory UnrecognizedFont.fromJson(Map<String, dynamic> json) =>
      UnrecognizedFont(
        fontName: json['fontName'],
        errorPhrase: json['errorPhrase'],
      );

  Map<String, dynamic> toJson() => {
        'fontName': fontName,
        'errorPhrase': errorPhrase,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnrecognizedFont &&
          runtimeType == other.runtimeType &&
          fontName == other.fontName &&
          errorPhrase == other.errorPhrase;

  @override
  int get hashCode => fontName.hashCode ^ errorPhrase.hashCode;
}
