import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:puntgpt_nick/core/extensions/context_extensions.dart';
import 'package:puntgpt_nick/core/responsive/breakpoints.dart';

/// Simpler responsive widget that takes widgets directly
//todo this is mainly use in the whole app
class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  // Check if current screen is mobile
  static bool isMobile(BuildContext context) =>
      context.screenWidth < Breakpoints.mobileBrowser;
  static bool isMobileWeb(BuildContext context) =>
      context.screenWidth < Breakpoints.tablet &&
      context.screenWidth > Breakpoints.mobileBrowser;

  //* Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    if (!kIsWeb) return false;
    return context.screenWidth >= Breakpoints.tablet &&
        context.screenWidth < Breakpoints.desktop;
  }
  // static bool isTablet(BuildContext context) {
  //   return context.screenWidth >= Breakpoints.tablet &&
  //     context.screenWidth < Breakpoints.desktop;
  // }

  //* Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    if (!kIsWeb) return false;

    return context.screenWidth >= Breakpoints.desktop;
  }

  /// Get current device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = context.screenWidth;
    if (width >= Breakpoints.desktop) return DeviceType.desktop;
    if (width >= Breakpoints.tablet) return DeviceType.tablet;
    if (context.screenWidth < Breakpoints.tablet &&
        context.screenWidth > Breakpoints.mobileBrowser) {
      return DeviceType.mobileBrowser;
    }
    return DeviceType.mobilePhysical;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= Breakpoints.desktop) {
          return desktop;
        } else if (context.screenWidth >= Breakpoints.tablet &&
            tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Device type enum
enum DeviceType { mobileBrowser, mobilePhysical, tablet, desktop }

/// Extension on BuildContext for easy responsive checks
extension ResponsiveContext on BuildContext {
  bool get isPhysicalMobile {
    // if (!kIsWeb) return false;
    return Responsive.isMobile(this);
  }

  bool get isBrowserMobile {
    return Responsive.isMobileWeb(this);
  }

  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  bool get isMobileView =>
      Responsive.isMobile(this) || Responsive.isMobileWeb(this);
  DeviceType get deviceType => Responsive.getDeviceType(this);
}
