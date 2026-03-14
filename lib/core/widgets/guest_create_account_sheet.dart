import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:puntgpt_nick/core/constants/app_assets.dart';
import 'package:puntgpt_nick/core/theme/app_colors.dart';
import 'package:puntgpt_nick/core/theme/text_style.dart';
import 'package:puntgpt_nick/core/widgets/app_filed_button.dart';
import 'package:puntgpt_nick/core/widgets/image_widget.dart';
import 'package:puntgpt_nick/core/router/app/app_routes.dart';
import 'package:puntgpt_nick/core/router/web/web_routes.dart';

void showGuestCreateAccountSheet(
  BuildContext context, {
  required String message,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    showDragHandle: true,
    useRootNavigator: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: ImageWidget(
                type: ImageType.svg,
                path: AppAssets.profile,
                height: 48.w,
              ),
            ),
            24.w.verticalSpace,
            Text(
              "Create account to continue",
              style: semiBold(
                fontSize: 20.sp,
                fontFamily: AppFontFamily.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            12.w.verticalSpace,
            Text(
              message,
              style: regular(
                fontSize: 15.sp,
                color: AppColors.primary.withValues(alpha: 0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            28.w.verticalSpace,
            AppFilledButton(
              text: "Create account",
              onTap: () {
                Navigator.of(sheetContext, rootNavigator: true).pop();
                context.pushNamed(
                  kIsWeb ? WebRoutes.signUpScreen.name : AppRoutes.signUpScreen.name,
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
