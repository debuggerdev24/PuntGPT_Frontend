import 'package:puntgpt_nick/core/app_imports.dart';

extension ResponsiveSize on int {
  double get fSize {
    if (kIsWeb) return toDouble();
    return sp ;
  }

  double get wSize {
    if (kIsWeb) return toDouble();
    return w;
  }

  double adaptiveSpacing(BuildContext context) {
    final base = toDouble();

    if (!kIsWeb) return base.w; // Mobile scaling

    final width = MediaQuery.of(context).size.width;

    if (width < 1200) return base; // laptop
    if (width < 1600) return (base * 1.1) > base ? base * 1.1 : base; // desktop
    return (base * 1.25) > base ? base * 1.25 : base; // large screens
  }
}

/*
-> for the common component of the app's UI which used in both, for mobile and web use the f.size extension.
-> For the Mobile screen UI use scrren util extension (like sp for fonts, r for radius) as I use for the mobile screens.
-> For the web screen UI do not use any kind of extension just use only constant  values (like 14, 16 etc, only)

*/
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
