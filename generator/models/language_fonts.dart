/// This model class is used for reading content from fonts.json and
/// error_handled\_fonts.json files.
class LanguageFonts {
  final String langName;
  final List<String> fontNames;

  const LanguageFonts({
    required this.langName,
    required this.fontNames,
  });

  factory LanguageFonts.fromJson(Map<String, dynamic> json) => LanguageFonts(
        langName: json['langName'],
        fontNames: List<String>.from(json['fontNames'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'langName': langName,
        'fontNames': List<dynamic>.from(fontNames.map((x) => x)),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageFonts &&
          runtimeType == other.runtimeType &&
          langName == other.langName &&
          fontNames == other.fontNames;

  @override
  int get hashCode => langName.hashCode ^ fontNames.hashCode;
}
