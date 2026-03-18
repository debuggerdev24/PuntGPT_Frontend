import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puntgpt_nick/core/responsive/responsive_builder.dart';

extension ResponsiveTextSize on int {
  double responsiveTextSize([double? min, double? max]) {
    return r
        .clamp(min ?? ((this - 2) <= 10 ? 10 : (this - 2)), max ?? (this + 2))
        .toDouble();
  }

  double responsiveSize([double? min, double? max]) {
    return w
        .clamp(min ?? ((this - 4) <= 8 ? 8 : (this - 4)), max ?? (this + 2))
        .toDouble();
  }

  double responsiveSpacing([double? min, double? max]) {
    return w
        .clamp(min ?? ((this - 5) <= 5 ? 5 : (this - 5)), max ?? (this + 5))
        .toDouble();
  }
}

extension FlexibleClamp on double {
  double flexClamp([double? min, double? max]) {
    double value = this;

    if (min != null && value < min) value = min;
    if (max != null && value > max) value = max;

    return value;
  }
}

extension ResponsiveTextScreenUtil on int {
  double sixteenSp(BuildContext context, {double? fontSize}) {
    if (fontSize != null) {
      if (context.isTablet) return (fontSize + 8).sp;
      if (context.isBrowserMobile) return (fontSize + 16).sp;
      return 16.sp;
    }

    if (context.isTablet) return 24.sp;
    if (context.isBrowserMobile) return 32.sp;
    return 16.sp; // desktop & fallback
  }

  double fourteenSp(BuildContext context, {double? fontSize}) {
    if (fontSize != null) {
      if (context.isTablet) return (fontSize + 8).sp;
      if (context.isBrowserMobile) return (fontSize + 16).sp;
      return 14.sp;
    }

    if (context.isTablet) return 22.sp;
    if (context.isBrowserMobile) return 30.sp;
    return 14.sp; // desktop & fallback
  }

  double twelveSp(BuildContext context, {double? fontSize}) {
    if (fontSize != null) {
      if (context.isTablet) return (fontSize + 8).sp;
      if (context.isBrowserMobile) return (fontSize + 16).sp;
      return 16.sp;
    }

    if (context.isTablet) return 20.sp;
    if (context.isBrowserMobile) return 28.sp;
    return 12.sp; // desktop & fallback
  }

  double twentyTwoSp(BuildContext context, {double? fontSize}) {
    if (fontSize != null) {
      if (context.isTablet) return (fontSize + 8).sp;
      if (context.isBrowserMobile) return (fontSize + 16).sp;
      return 16.sp;
    }

    if (context.isTablet) return 30.sp;
    if (context.isBrowserMobile) return 38.sp;
    return 22.sp; // desktop & fallback
  }

  double twentyFourSp(BuildContext context, {double? fontSize}) {
    if (fontSize != null) {
      if (context.isTablet) return (fontSize + 8).sp;
      if (context.isBrowserMobile) return (fontSize + 16).sp;
      return 24.sp;
    }

    if (context.isTablet) return 32.sp;
    if (context.isBrowserMobile) return 40.sp;
    return 24.sp; // desktop & fallback
  }

  double eighteenSp(BuildContext context, {double? fontSize}) {
    if (fontSize != null) {
      if (context.isTablet) return (fontSize + 8).sp;
      if (context.isBrowserMobile) return (fontSize + 16).sp;
      return 18.sp;
    }

    if (context.isTablet) return 26.sp;
    if (context.isBrowserMobile) return 34.sp;
    return 18.sp;
  }


}
