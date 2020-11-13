// GENERATED CODE - DO NOT EDIT

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'src/google_fonts_base.dart';
import 'src/google_fonts_descriptor.dart';
import 'src/google_fonts_variant.dart';

/// A collection of properties used to specify custom behavior of the
/// GoogleFonts library.
class _Config {
  /// Whether or not the GoogleFonts library can make requests to
  /// [fonts.google.com](https://fonts.google.com/) to retrieve font files.
  var allowRuntimeFetching = true;
}

class GoogleFonts {
  /// Configuration for the [GoogleFonts] library.
  ///
  /// Use this to define custom behavior of the GoogleFonts library in your app.
  /// For example, if you do not want the GoogleFonts library to make any http
  /// requests for fonts, add the following snippet to your app's `main` method.
  ///
  /// ```dart
  /// GoogleFonts.config.allowRuntimeFetching = false;
  /// ```
  static final config = _Config();

  /// Get a map of all available fonts.
  ///
  /// Returns a map where the key is the name of the font family and the value
  /// is the corresponding [GoogleFonts] method.
  static Map<String, TextStyle Function({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  })> asMap() => const {
    'Lato': GoogleFonts.lato,
    'Noto Sans': GoogleFonts.notoSans,
    'PT Mono': GoogleFonts.ptMono,
    'Roboto': GoogleFonts.roboto,
  };

  /// Get a map of all available fonts and their associated text themes.
  ///
  /// Returns a map where the key is the name of the font family and the value
  /// is the corresponding [GoogleFonts] `TextTheme` method.
  static Map<String, TextTheme Function([TextTheme])> _asMapOfTextThemes() => const {
    'Lato': GoogleFonts.latoTextTheme,
    'Noto Sans': GoogleFonts.notoSansTextTheme,
    'PT Mono': GoogleFonts.ptMonoTextTheme,
    'Roboto': GoogleFonts.robotoTextTheme,
  };

  /// Retrieve a font by family name.
  /// 
  /// Applies the given font family from Google Fonts to the given [textStyle]
  /// and returns the resulting [TextStyle].
  ///
  /// Note: [fontFamily] is case-sensitive.
  /// 
  /// Parameter [fontFamily] must not be `null`. Throws if no font by name
  /// [fontFamily] exists.
  static TextStyle getFont(String fontFamily, {
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    assert(fontFamily != null);
    final fonts = GoogleFonts.asMap();
    if (!fonts.containsKey(fontFamily)) {
      throw Exception("No font family by name '$fontFamily' was found.");
    }
    return fonts[fontFamily](
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Retrieve a text theme by its font family name.
  ///
  /// Applies the given font family from Google Fonts to the given [textTheme]
  /// and returns the resulting [textTheme].
  ///
  /// Note: [fontFamily] is case-sensitive.
  ///
  /// Parameter [fontFamily] must not be `null`. Throws if no font by name
  /// [fontFamily] exists.
  static TextTheme getTextTheme(String fontFamily, [TextTheme textTheme]) {
    assert(fontFamily != null);
    final fonts = _asMapOfTextThemes();
    if (!fonts.containsKey(fontFamily)) {
      throw Exception("No font family by name '$fontFamily' was found.");
    }
    return fonts[fontFamily](textTheme);
  }

  /// Applies the Lato font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextStyle lato({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    final fonts = <GoogleFontsVariant, GoogleFontsFile>{
      GoogleFontsVariant(fontWeight: FontWeight.w100, fontStyle: FontStyle.normal,): GoogleFontsFile('2e734a39ad0b4a1dffd327f552cce678e867791007200be49b6a93a6c7c71b27', 83268,),
      GoogleFontsVariant(fontWeight: FontWeight.w100, fontStyle: FontStyle.italic,): GoogleFontsFile('00d4076b836620336e608f16588994045e53f8aca14d9e430205db56649a8a55', 78920,),
      GoogleFontsVariant(fontWeight: FontWeight.w300, fontStyle: FontStyle.normal,): GoogleFontsFile('9b25850654f3dd59daf526a3d63dcca1c435e231c9fa2dd949ccde9cea994366', 80608,),
      GoogleFontsVariant(fontWeight: FontWeight.w300, fontStyle: FontStyle.italic,): GoogleFontsFile('4cf23877950718d8775e526ee06380072a1bba6692d47bb5fb623fefb650b74b', 79388,),
      GoogleFontsVariant(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal,): GoogleFontsFile('a649aaf21573a59079c46db19314fd95648f531e610fa932101f2705616b2882', 80676,),
      GoogleFontsVariant(fontWeight: FontWeight.w400, fontStyle: FontStyle.italic,): GoogleFontsFile('484dd58cc095656f129f756067ede55183de20d70a6260c22ac747ed583672d6', 79376,),
      GoogleFontsVariant(fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,): GoogleFontsFile('407592da08cb1f6060fbc69262ad33edd0b61ec9160521455eca8f726bbd4353', 84716,),
      GoogleFontsVariant(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic,): GoogleFontsFile('6449b474d050304983a9431099406936e7f6978e22025a4a5ff8533871529bba', 79536,),
      GoogleFontsVariant(fontWeight: FontWeight.w900, fontStyle: FontStyle.normal,): GoogleFontsFile('abae7ec6de16f8108f1a3e1e3dc9edf11c5903ab89b3513821f4e079a51ae175', 81116,),
      GoogleFontsVariant(fontWeight: FontWeight.w900, fontStyle: FontStyle.italic,): GoogleFontsFile('60407472b091a98e26c61f47900329eb3f971651fa76edc26d9f32f87e27f13f', 76532,),
    };

    return googleFontsTextStyle(
      textStyle: textStyle,
      fontFamily: 'Lato',
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fonts: fonts,
    );
  }

  /// Applies the Lato font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextTheme latoTextTheme([TextTheme textTheme]) {
    textTheme ??= ThemeData.light().textTheme;
    return TextTheme(
      headline1: GoogleFonts.lato(textStyle: textTheme?.headline1),
      headline2: GoogleFonts.lato(textStyle: textTheme?.headline2),
      headline3: GoogleFonts.lato(textStyle: textTheme?.headline3),
      headline4: GoogleFonts.lato(textStyle: textTheme?.headline4),
      headline5: GoogleFonts.lato(textStyle: textTheme?.headline5),
      headline6: GoogleFonts.lato(textStyle: textTheme?.headline6),
      subtitle1: GoogleFonts.lato(textStyle: textTheme?.subtitle1),
      subtitle2: GoogleFonts.lato(textStyle: textTheme?.subtitle2),
      bodyText1: GoogleFonts.lato(textStyle: textTheme?.bodyText1),
      bodyText2: GoogleFonts.lato(textStyle: textTheme?.bodyText2),
      caption: GoogleFonts.lato(textStyle: textTheme?.caption),
      button: GoogleFonts.lato(textStyle: textTheme?.button),
      overline: GoogleFonts.lato(textStyle: textTheme?.overline),
    );
  }

  /// Applies the Noto Sans font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextStyle notoSans({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    final fonts = <GoogleFontsVariant, GoogleFontsFile>{
      GoogleFontsVariant(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal,): GoogleFontsFile('7ae7b625c88992d250a617f91f64e254aa6ea78ca904f1e5fc1f588f0bb9a4ef', 310656,),
      GoogleFontsVariant(fontWeight: FontWeight.w400, fontStyle: FontStyle.italic,): GoogleFontsFile('3b65d8f4cdb5997c9e205e125755bec66ef6cd73fadfbf1b6b8b8592d4a952e3', 211128,),
      GoogleFontsVariant(fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,): GoogleFontsFile('f16366c45a8cac801cadd57c692f16cf4c967e3758cf25a911f7df101c23dc11', 307772,),
      GoogleFontsVariant(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic,): GoogleFontsFile('2b36c5bae3f90cb9def112b8d15a224e0f0e4a0a75a5d83718690c6927872140', 214176,),
    };

    return googleFontsTextStyle(
      textStyle: textStyle,
      fontFamily: 'NotoSans',
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fonts: fonts,
    );
  }

  /// Applies the Noto Sans font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextTheme notoSansTextTheme([TextTheme textTheme]) {
    textTheme ??= ThemeData.light().textTheme;
    return TextTheme(
      headline1: GoogleFonts.notoSans(textStyle: textTheme?.headline1),
      headline2: GoogleFonts.notoSans(textStyle: textTheme?.headline2),
      headline3: GoogleFonts.notoSans(textStyle: textTheme?.headline3),
      headline4: GoogleFonts.notoSans(textStyle: textTheme?.headline4),
      headline5: GoogleFonts.notoSans(textStyle: textTheme?.headline5),
      headline6: GoogleFonts.notoSans(textStyle: textTheme?.headline6),
      subtitle1: GoogleFonts.notoSans(textStyle: textTheme?.subtitle1),
      subtitle2: GoogleFonts.notoSans(textStyle: textTheme?.subtitle2),
      bodyText1: GoogleFonts.notoSans(textStyle: textTheme?.bodyText1),
      bodyText2: GoogleFonts.notoSans(textStyle: textTheme?.bodyText2),
      caption: GoogleFonts.notoSans(textStyle: textTheme?.caption),
      button: GoogleFonts.notoSans(textStyle: textTheme?.button),
      overline: GoogleFonts.notoSans(textStyle: textTheme?.overline),
    );
  }

  /// Applies the PT Mono font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextStyle ptMono({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    final fonts = <GoogleFontsVariant, GoogleFontsFile>{
      GoogleFontsVariant(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal,): GoogleFontsFile('76d11b0f53258fdd742b27fc7e194046840c2fc0cafe1246aa0c27718a5f031a', 84568,),
    };

    return googleFontsTextStyle(
      textStyle: textStyle,
      fontFamily: 'PTMono',
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fonts: fonts,
    );
  }

  /// Applies the PT Mono font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextTheme ptMonoTextTheme([TextTheme textTheme]) {
    textTheme ??= ThemeData.light().textTheme;
    return TextTheme(
      headline1: GoogleFonts.ptMono(textStyle: textTheme?.headline1),
      headline2: GoogleFonts.ptMono(textStyle: textTheme?.headline2),
      headline3: GoogleFonts.ptMono(textStyle: textTheme?.headline3),
      headline4: GoogleFonts.ptMono(textStyle: textTheme?.headline4),
      headline5: GoogleFonts.ptMono(textStyle: textTheme?.headline5),
      headline6: GoogleFonts.ptMono(textStyle: textTheme?.headline6),
      subtitle1: GoogleFonts.ptMono(textStyle: textTheme?.subtitle1),
      subtitle2: GoogleFonts.ptMono(textStyle: textTheme?.subtitle2),
      bodyText1: GoogleFonts.ptMono(textStyle: textTheme?.bodyText1),
      bodyText2: GoogleFonts.ptMono(textStyle: textTheme?.bodyText2),
      caption: GoogleFonts.ptMono(textStyle: textTheme?.caption),
      button: GoogleFonts.ptMono(textStyle: textTheme?.button),
      overline: GoogleFonts.ptMono(textStyle: textTheme?.overline),
    );
  }

  /// Applies the Roboto font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextStyle roboto({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    final fonts = <GoogleFontsVariant, GoogleFontsFile>{
      GoogleFontsVariant(fontWeight: FontWeight.w100, fontStyle: FontStyle.normal,): GoogleFontsFile('e735762739638d19335103f8e7a343545560f4b2265fd35a4f0f516f512a7760', 109484,),
      GoogleFontsVariant(fontWeight: FontWeight.w100, fontStyle: FontStyle.italic,): GoogleFontsFile('aece4c53901fff188a2cb1aab1024ea53b459e2181d47d9b3700c13d33ade89e', 116036,),
      GoogleFontsVariant(fontWeight: FontWeight.w300, fontStyle: FontStyle.normal,): GoogleFontsFile('9d1bd6e2cc14a33517018f1bbfdc878cb18e7894f39fc7c36436ae18440621e7', 108652,),
      GoogleFontsVariant(fontWeight: FontWeight.w300, fontStyle: FontStyle.italic,): GoogleFontsFile('0810007c837dfd034071c166e5f3ed111b0180b2f6af17a5c14e006a8e05784f', 115656,),
      GoogleFontsVariant(fontWeight: FontWeight.w400, fontStyle: FontStyle.normal,): GoogleFontsFile('030868028bda24a27a45e0be44c8ae15544762b94f80da746c8b8a1c05f8e952', 107800,),
      GoogleFontsVariant(fontWeight: FontWeight.w400, fontStyle: FontStyle.italic,): GoogleFontsFile('6a79346603274d80f27fb4de32a0e7a60f62c53c8069df2750e79b8f10e30649', 114644,),
      GoogleFontsVariant(fontWeight: FontWeight.w500, fontStyle: FontStyle.normal,): GoogleFontsFile('388ace661d10e5756d4de58035d6687cf35c0b11c8185b098468741ca2e8a6d4', 109344,),
      GoogleFontsVariant(fontWeight: FontWeight.w500, fontStyle: FontStyle.italic,): GoogleFontsFile('257c7750d0c1570dc2324571f2998d43e18649848595361a6b136bb0d3d2efb2', 116372,),
      GoogleFontsVariant(fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,): GoogleFontsFile('ba3855457bdc103784c39219f0ce666683084df07dbd7eb7d8c35a40cf8f1c8b', 109712,),
      GoogleFontsVariant(fontWeight: FontWeight.w700, fontStyle: FontStyle.italic,): GoogleFontsFile('8c9936227e9fe936594819bbf4aa9a26d9b044f0b440800a4ade3e3e749f54aa', 116424,),
      GoogleFontsVariant(fontWeight: FontWeight.w900, fontStyle: FontStyle.normal,): GoogleFontsFile('a1ba74d13db1b16771b1d8e705e4c9282ef1d09492783304ebc025adb6ba1914', 109832,),
      GoogleFontsVariant(fontWeight: FontWeight.w900, fontStyle: FontStyle.italic,): GoogleFontsFile('a4c423dcbda812fa36cb0325f3aad0fd9847e8a5b0a26f31094db0666e721c8c', 116668,),
    };

    return googleFontsTextStyle(
      textStyle: textStyle,
      fontFamily: 'Roboto',
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fonts: fonts,
    );
  }

  /// Applies the Roboto font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextTheme robotoTextTheme([TextTheme textTheme]) {
    textTheme ??= ThemeData.light().textTheme;
    return TextTheme(
      headline1: GoogleFonts.roboto(textStyle: textTheme?.headline1),
      headline2: GoogleFonts.roboto(textStyle: textTheme?.headline2),
      headline3: GoogleFonts.roboto(textStyle: textTheme?.headline3),
      headline4: GoogleFonts.roboto(textStyle: textTheme?.headline4),
      headline5: GoogleFonts.roboto(textStyle: textTheme?.headline5),
      headline6: GoogleFonts.roboto(textStyle: textTheme?.headline6),
      subtitle1: GoogleFonts.roboto(textStyle: textTheme?.subtitle1),
      subtitle2: GoogleFonts.roboto(textStyle: textTheme?.subtitle2),
      bodyText1: GoogleFonts.roboto(textStyle: textTheme?.bodyText1),
      bodyText2: GoogleFonts.roboto(textStyle: textTheme?.bodyText2),
      caption: GoogleFonts.roboto(textStyle: textTheme?.caption),
      button: GoogleFonts.roboto(textStyle: textTheme?.button),
      overline: GoogleFonts.roboto(textStyle: textTheme?.overline),
    );
  }

}

class ArabicFonts {
  /// Applies the Lato font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextStyle lato({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.lato(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Lato font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextTheme latoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.latoTextTheme(textTheme);
  }
  /// Applies the Noto Sans font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextStyle notoSans({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.notoSans(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Noto Sans font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextTheme notoSansTextTheme([TextTheme textTheme]) {
    return GoogleFonts.notoSansTextTheme(textTheme);
  }
  /// Applies the PT Mono font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextStyle ptMono({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.ptMono(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the PT Mono font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextTheme ptMonoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.ptMonoTextTheme(textTheme);
  }
  /// Applies the Roboto font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextStyle roboto({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.roboto(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Roboto font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextTheme robotoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.robotoTextTheme(textTheme);
  }
}

class CyrillicFonts {
  /// Applies the Lato font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextStyle lato({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.lato(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Lato font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextTheme latoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.latoTextTheme(textTheme);
  }
  /// Applies the Noto Sans font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextStyle notoSans({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.notoSans(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Noto Sans font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextTheme notoSansTextTheme([TextTheme textTheme]) {
    return GoogleFonts.notoSansTextTheme(textTheme);
  }
  /// Applies the PT Mono font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextStyle ptMono({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.ptMono(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the PT Mono font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextTheme ptMonoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.ptMonoTextTheme(textTheme);
  }
  /// Applies the Roboto font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextStyle roboto({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.roboto(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Roboto font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextTheme robotoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.robotoTextTheme(textTheme);
  }
}

class LatinExtFonts {
  /// Applies the Lato font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextStyle lato({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.lato(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Lato font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Lato
  static TextTheme latoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.latoTextTheme(textTheme);
  }
  /// Applies the Noto Sans font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextStyle notoSans({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.notoSans(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Noto Sans font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Noto+Sans
  static TextTheme notoSansTextTheme([TextTheme textTheme]) {
    return GoogleFonts.notoSansTextTheme(textTheme);
  }
  /// Applies the PT Mono font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextStyle ptMono({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.ptMono(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the PT Mono font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/PT+Mono
  static TextTheme ptMonoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.ptMonoTextTheme(textTheme);
  }
  /// Applies the Roboto font family from Google Fonts to the
  /// given [textStyle].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextStyle roboto({
    TextStyle textStyle,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<ui.Shadow> shadows,
    List<ui.FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
  }) {
    return GoogleFonts.roboto(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// Applies the Roboto font family from Google Fonts to every
  /// [TextStyle] in the given [textTheme].
  ///
  /// See:
  ///  * https://fonts.google.com/specimen/Roboto
  static TextTheme robotoTextTheme([TextTheme textTheme]) {
    return GoogleFonts.robotoTextTheme(textTheme);
  }
}

