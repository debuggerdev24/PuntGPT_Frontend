
import 'package:puntgpt_nick/core/app_imports.dart';
class AppFontFamily {
  AppFontFamily._();

  static const primary = "DMSans";
  static const secondary = "ChangaOne";
}

// 🪶 Light
TextStyle light({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  double? letterSpacing,
  FontStyle? fontStyle,
}) => TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: fontSize,
  height: height,
  color: color ?? AppColors.primary,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
  letterSpacing: letterSpacing,
  fontStyle: fontStyle,
);

/// Regular
TextStyle regular({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  double? letterSpacing,
  FontStyle? fontStyle,
}) => TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: fontSize,
  height: height,
  color: color ?? AppColors.primary,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
  letterSpacing: letterSpacing,
  fontStyle: fontStyle,
);

/// Medium
TextStyle medium({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  double? letterSpacing,
  FontStyle? fontStyle,
}) => TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: fontSize,
  height: height,
  color: color ?? AppColors.primary,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
  letterSpacing: letterSpacing,
  fontStyle: fontStyle,
);

/// SemiBold
TextStyle semiBold({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  double? letterSpacing,
  FontStyle? fontStyle,
}) => TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: fontSize,
  height: height,
  color: color ?? AppColors.primary,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
  letterSpacing: letterSpacing,
  fontStyle: fontStyle,
);

/// Bold
TextStyle bold({
  double fontSize = 20,
  double? height,
  Color? color,
  String? fontFamily,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  double? letterSpacing,
  FontStyle? fontStyle,
}) => TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: fontSize,
  height: height,
  color: color ?? AppColors.primary,
  fontFamily: fontFamily,
  decoration: decoration,
  decorationColor: decorationColor,
  decorationStyle: decorationStyle,
  decorationThickness: decorationThickness,
  letterSpacing: letterSpacing,
  fontStyle: fontStyle,
);
