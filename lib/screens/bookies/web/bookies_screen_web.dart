import 'package:puntgpt_nick/core/app_imports.dart';

import 'package:puntgpt_nick/screens/dashboard/web/web_dashboard.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';

class BookiesScreenWeb extends StatelessWidget {
  const BookiesScreenWeb({super.key});

  void _goHome() {
    indexOfWebTab.value = 2;
    WebRouter.indexedStackNavigationShell?.goBranch(2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColoredBox(
          color: AppColors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppScreenTopBar(
                  title: "Bookies",
                  slogan: "Partner offers and exclusive deals",
                  onBack: _goHome,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 120.h),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 560.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Tap the banner below to visit our partner.",
                            style: regular(
                              fontSize: 15.sp,
                              height: 1.35,
                              color: AppColors.primary.withValues(alpha: 0.65),
                            ),
                          ),
                          20.h.verticalSpace,
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
                                      horizontal: 16.w,
                                      vertical: 14.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.touch_app_rounded,
                                          size: 20.sp,
                                          color: AppColors.primary.withValues(
                                            alpha: 0.75,
                                          ),
                                        ),
                                        10.w.horizontalSpace,
                                        Expanded(
                                          child: Text(
                                            "Tap to open Dabble",
                                            style: medium(
                                              fontSize: 14.sp,
                                              color: AppColors.primary.withValues(
                                                alpha: 0.85,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.open_in_new_rounded,
                                          size: 18.sp,
                                          color: AppColors.primary.withValues(
                                            alpha: 0.5,
                                          ),
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
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentGeometry.bottomRight,
          child: askPuntGPTButtonWeb(context: context),
        ),
      ],
    );
  }
}
