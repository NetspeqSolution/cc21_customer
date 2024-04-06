import 'package:flutter/material.dart';
import '../components/palette.dart';
import 'constants.dart';

ThemeData cc21CustomerTheme() {

  return ThemeData(
      primaryColor: Palette.primary,
      primarySwatch: Palette.primary,
      colorScheme: const ColorScheme.light(
        primary: Palette.primary,
        //secondary: Palette.secondary,
      ),
      fontFamily: "NotoSans",
      scaffoldBackgroundColor: kWhite,
      primaryTextTheme: textTheme(),
      textTheme: textTheme());
}

TextTheme textTheme() {
  return TextTheme(
    displayLarge: TextStyle(fontFamily: "NotoSans", color: kBlack),
    displayMedium: TextStyle(fontFamily: "NotoSans", color: kBlack),
    displaySmall: TextStyle(fontFamily: "NotoSans", color: kBlack),
    headlineLarge: TextStyle(fontFamily: "NotoSans", color: kBlack),
    headlineMedium: TextStyle(fontFamily: "NotoSans", color: kBlack),
    headlineSmall: TextStyle(fontFamily: "NotoSans", color: kBlack),
    titleLarge: TextStyle(fontFamily: "NotoSans", color: kBlack),
    titleMedium: TextStyle(fontFamily: "NotoSans", color: kBlack),
    titleSmall: TextStyle(fontFamily: "NotoSans", color: kBlack),
    bodyLarge: TextStyle(fontFamily: "NotoSans", color: kBlack),
    bodyMedium: TextStyle(fontFamily: "NotoSans", color: kBlack),
    bodySmall: TextStyle(fontFamily: "NotoSans", color: kBlack),
    labelLarge: TextStyle(fontFamily: "NotoSans", color: kBlack),
    labelMedium: TextStyle(fontFamily: "NotoSans", color: kBlack),
    labelSmall: TextStyle(fontFamily: "NotoSans", color: kBlack)
  );
}
