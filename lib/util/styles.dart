import 'package:flutter/material.dart';

const double ICON_SIZE_12 = 12;
const double ICON_SIZE_16 = 16;
const double ICON_SIZE_20 = 20;
const double ICON_SIZE_24 = 24;
const double ICON_SIZE_28 = 28;
const double ICON_SIZE_32 = 32;
const double ICON_SIZE_36 = 36;
const double ICON_SIZE_40 = 40;

const double FONT_SIZE_12 = 12.0;
const double FONT_SIZE_14 = 14.0;
const double FONT_SIZE_16 = 16.0;
const double FONT_SIZE_18 = 18.0;
const double FONT_SIZE_20 = 20.0;
const double FONT_SIZE_24 = 24.0;
const double FONT_SIZE_28 = 28.0;
const double FONT_SIZE_32 = 32.0;
const double FONT_SIZE_36 = 36.0;
const double FONT_SIZE_40 = 40.0;

const double SPACE_SIZE_1 = 1.0;
const double SPACE_SIZE_2 = 2.0;
const double SPACE_SIZE_4 = 4.0;
const double SPACE_SIZE_8 = 8.0;
const double SPACE_SIZE_12 = 12.0;
const double SPACE_SIZE_16 = 16.0;
const double SPACE_SIZE_20 = 20.0;
const double SPACE_SIZE_24 = 24.0;
const double SPACE_SIZE_28 = 28.0;
const double SPACE_SIZE_32 = 32.0;
const double SPACE_SIZE_36 = 36.0;
const double SPACE_SIZE_40 = 40.0;

TextStyle getTextStyle(BuildContext context, Color color, double scale) {
  const fontFamily = 'NotoSerifJP';
  const fontWeight = FontWeight.w400;
  double screenWidth = MediaQuery.of(context).size.width;
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: color,
    fontSize: screenWidth * scale,
  );
}

TextTheme getTextTheme(BuildContext context, Color color) {
  return TextTheme(
    labelSmall: getTextStyle(context, color, 0.04),
    labelMedium: getTextStyle(context, color, 0.05),
    labelLarge: getTextStyle(context, color, 0.06),
    bodySmall: getTextStyle(context, color, 0.04),
    bodyMedium: getTextStyle(context, color, 0.05),
    bodyLarge: getTextStyle(context, color, 0.06),
    headlineSmall: getTextStyle(context, color, 0.05),
    headlineMedium: getTextStyle(context, color, 0.06),
    headlineLarge: getTextStyle(context, color, 0.07),
    titleSmall: getTextStyle(context, color, 0.05),
    titleMedium: getTextStyle(context, color, 0.06),
    titleLarge: getTextStyle(context, color, 0.07),
    displaySmall: getTextStyle(context, color, 0.06),
    displayMedium: getTextStyle(context, color, 0.07),
    displayLarge: getTextStyle(context, color, 0.08),
  );
}

TextTheme getLightTextTheme(BuildContext context) => getTextTheme(context, const Color.fromARGB(255, 0, 0, 0));
TextTheme getDarkTextTheme(BuildContext context) => getTextTheme(context, const Color.fromARGB(255, 255, 255, 255));

// TODO ::: 버튼 테마 추가
