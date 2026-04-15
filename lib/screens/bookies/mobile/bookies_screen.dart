import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/dashboard/mobile/dashboard.dart';

class BookiesScreen extends StatelessWidget {
  const BookiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        indexOfTab.value = 0;
        AppRouter.indexedStackNavigationShell?.goBranch(0);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppScreenTopBar(
            title: "Bookies",
            slogan: "Use code 'PUNTGPT'",
            onBack: () {
              
              indexOfTab.value = 0;
              AppRouter.indexedStackNavigationShell?.goBranch(0);
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.w, 20.w, 24.h),
              children: [
                16.w.verticalSpace,
                Material(
                  color: AppColors.white,
                  elevation: 2,
                  shadowColor: AppColors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => launchDabbleUrl(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ImageWidget(
                          path: AppAssets.dabbleAdvertisement1,
                          type: ImageType.asset,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.w,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                size: 18.sp,
                                color: AppColors.primary.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                              8.w.horizontalSpace,
                              Expanded(
                                child: Text(
                                  "Tap to open Dabble",
                                  style: medium(
                                    fontSize: 13.sp,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.85,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.open_in_new_rounded,
                                size: 16.sp,
                                color: AppColors.primary.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
