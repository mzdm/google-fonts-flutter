/// How likely a font supports Czech characters.
///
/// HIGHEST means that it most certainly supports.
enum Confidence { ANY, HIGHEST, HIGH, MEDIUM, LOW, LOWEST }

extension EnumExt on Confidence {
  /// This will convert a value of Confidence enum to String.
  ///
  /// For example: Confidence.LOWEST -> LOWEST
  String describe() => toString().split('.').last;
}

/// This model class is used for reading content from czech_fonts.json.
///
/// Source of this file is: https://github.com/mzdm/czech_fonts
class CzechFont {
  final String fontName;
  final Confidence confidence;

  const CzechFont({
    required this.fontName,
    required this.confidence,
  });

  static CzechFont fromJson(Map<String, dynamic> json) => CzechFont(
        fontName: json['fontName'],
        confidence: _getConfidenceFromJson(json['confidence']),
      );

  Map<String, dynamic> toJson() => {
        'fontName': fontName,
        'confidence': confidence.describe(),
      };

  static Confidence _getConfidenceFromJson(String val) {
    for (final confidence in Confidence.values) {
      if (val == confidence.describe()) {
        return confidence;
      }
    }
    return Confidence.ANY;
  }

  @override
  String toString() =>
      'CzechFont{fontName: $fontName, confidence: $confidence}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CzechFont &&
          runtimeType == other.runtimeType &&
          fontName == other.fontName &&
          confidence == other.confidence;

  @override
  int get hashCode => fontName.hashCode ^ confidence.hashCode;
}
