import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/services/network/network_service.dart';

/// Mobile-only offline UI. Shown when there is no internet connection.
class MobileOfflineView extends StatelessWidget {
  const MobileOfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backGroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(context),
              32.w.verticalSpace,
              Text(
                "No internet connection",
                textAlign: TextAlign.center,
                style: bold(
                  fontSize: 22.sp,
                  color: AppColors.primary,
                ),
              ),
              12.h.verticalSpace,
              Text(
                "Check your Wi‑Fi or mobile data and try again.",
                textAlign: TextAlign.center,
                style: regular(
                  fontSize: 16.sp,
                  color: AppColors.primary.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
              40.h.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: AppFilledButton(
                  text: "Try again",
                  onTap: () => NetworkService.instance.recheck(),
                  color: AppColors.primary,
                  textStyle: semiBold(
                    fontSize: 16.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        shape: BoxShape.circle,
      ),
      child: Icon(
        CupertinoIcons.wifi_slash,
        size: 64.w,
        color: AppColors.primary.withValues(alpha: 0.5),
      ),
    );
  }
}
