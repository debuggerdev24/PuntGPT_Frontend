
import 'package:puntgpt_nick/core/app_imports.dart';

class SubscriptionGateView extends StatelessWidget {
  const SubscriptionGateView({
    super.key,
    required this.featureTitle,
    required this.featureDescription,
    this.icon = Icons.workspace_premium_rounded,
  });

  final String featureTitle;
  final String featureDescription;
  final IconData icon;

  void _openManageSubscription(BuildContext context) {
    
    context.pushNamed(
      (kIsWeb && context.isMobileView)
          ? WebRoutes.manageSubscriptionScreen.name
          : AppRoutes.manageSubscriptionScreen.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all((context.isBrowserMobile) ? 28.w : 22.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: (context.isBrowserMobile) ? 72.w : 52.w,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
            24.h.verticalSpace,
            Text(
              featureTitle,
              style: semiBold(
                fontSize: (context.isBrowserMobile) ? 28.sp : 20.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            12.h.verticalSpace,
            Text(
              featureDescription,
              style: regular(
                fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
                color: AppColors.primary.withValues(alpha: 0.65),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            28.h.verticalSpace,
            AppFilledButton(
              onTap: () => _openManageSubscription(context),
              text: "Subscribe to Pro",
              textStyle: semiBold(
                fontSize: (context.isBrowserMobile) ? 26.sp : 16.sp,
                color: AppColors.white,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 14.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
