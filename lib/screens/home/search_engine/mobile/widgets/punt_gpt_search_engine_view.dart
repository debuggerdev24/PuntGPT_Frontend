import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/race_start_timing_options.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/search_section.dart';

class PuntGptSearchEngineView extends StatelessWidget {
  const PuntGptSearchEngineView({
    super.key,
    required this.provider,
    this.formKey,
  });

  final SearchEngineProvider provider;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    final bodyHorizontalPadding = (context.isMobileWeb) ? 50.w : 20.w;

    return Column(
      spacing: 16,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.w),
            child: Column(
              children: [
                //* Tagline + Saved Searches (single row; tagline scales down if narrow)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    bodyHorizontalPadding,
                    0,
                    bodyHorizontalPadding,
                    14.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Filter through form your way",
                              maxLines: 1,
                              softWrap: false,
                              style: semiBold(
                                fontSize: (context.isMobileWeb)
                                    ? 28.sp
                                    : 15.sp,
                                height: 1.15,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      10.w.horizontalSpace,
                      OnMouseTap(
                        onTap: () {
                          context.pushNamed(
                            (context.isMobile)
                                ? AppRoutes.savedSearchedScreen.name
                                : WebRoutes.savedSearchedScreen.name,
                          );
                          if (context
                              .read<SubscriptionProvider>()
                              .isSubscribed) {
                            provider.getAllSaveSearch();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ImageWidget(
                                type: ImageType.svg,
                                path: AppAssets.bookmark,
                                height: 16.w.flexClamp(14, 18),
                                color: AppColors.primary,
                              ),
                              6.w.horizontalSpace,
                              Text(
                                "Saved Searches",
                                overflow: TextOverflow.ellipsis,
                                style: semiBold(
                                  fontSize: (context.isMobileWeb)
                                      ? 26.sp
                                      : 14.sp,
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //* Race Start Timing Options (Jumps within 10 minutes)
                RaceStartTimingOptions(),

                //* Search Fields
                SearchFields(providerh: provider),

                // IntrinsicWidth(
                //   child: AppFilledButton(
                //     margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.w),
                //     text: "Search",
                //     textStyle: semiBold(
                //       fontSize: 16.sixteenSp(context),
                //       color: AppColors.white,
                //     ),
                //     onTap: () {
                //       context.pushNamed(AppRoutes.runnersScreen.name);
                //       provider.getUpcomingRunner(onSuccess: () {});
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
