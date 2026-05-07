import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/responsive/responsive_builder.dart';

import '../theme/app_colors.dart' show AppColors;

class FullPageIndicator extends StatelessWidget {
  const FullPageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.black.withValues(alpha: 0.4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(7).r,
        ),
        padding: EdgeInsets.all(
          (kIsWeb && context.isMobileView) ? 24 : 12,
        ).r,
        child: CupertinoActivityIndicator(
          radius: (kIsWeb) ? 20.w : 19.w,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

Widget webProgressIndicator(BuildContext context, {Color? color}) {
  return SizedBox(
    width: (context.isDesktop) ? 35.w : 45.w,
    height: (context.isDesktop) ? 35.w : 45.w,
    child: CircularProgressIndicator(
      strokeWidth: 2.5,
      color: color ?? AppColors.white,
      strokeCap: StrokeCap.round,
    ),
  );
}

Widget progressIndicator({Color? color, double? size}) {
  final s = size ?? 28.wSize;
  return SizedBox(
    width: s,
    height: s,
    child: CircularProgressIndicator(
      strokeWidth: 2.5,
      color: color ?? AppColors.white,
      strokeCap: StrokeCap.round,
    ),
  );
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.86.sh,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5).r,
        ),
        padding: EdgeInsets.all(12).r,
        child: CupertinoActivityIndicator(
          radius: 18.h,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
