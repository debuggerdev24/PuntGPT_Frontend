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
    final bodyHorizontalPadding = (context.isBrowserMobile) ? 50.w : 25.w;

    return Column(
      spacing: 16,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.w),
            child: Column(
              children: [
                //* Saved Searches title
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    bodyHorizontalPadding,

                    0,
                    bodyHorizontalPadding,
                    20.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          "Search for a horse that meets your criteria:",
                          style: bold(
                            fontSize: (context.isBrowserMobile) ? 36.sp : 16.sp,
                            height: 1.2,
                          ),
                        ),
                      ),
                      OnMouseTap(
                        onTap: () {
                          context.pushNamed(
                            (context.isPhysicalMobile)
                                ? AppRoutes.savedSearchedScreen.name
                                : WebRoutes.savedSearchedScreen.name,
                          );
                          if (context
                              .read<SubscriptionProvider>()
                              .isSubscribed) {
                            provider.getAllSaveSearch();
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageWidget(
                              type: ImageType.svg,
                              path: AppAssets.bookmark,
                              height: 16.w.flexClamp(14, 18),
                            ),
                            5.w.horizontalSpace,
                            Text(
                              "Saved Searches",
                              style: bold(
                                fontSize: (context.isBrowserMobile)
                                    ? 36.sp
                                    : 16.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
               //* Race Start Timing Options (Jumps within 10 minutes) 
               RaceStartTimingOptions(),
               
                //* Search Fields
                SearchFields(providerh: provider),

                //* Search Button
                IntrinsicWidth(
                  child: AppFilledButton(
                    margin: EdgeInsets.only(left: 24.w,right: 24.w,top: 20.w),
                    text: "Search",
                    textStyle: semiBold(
                      fontSize: 16.sixteenSp(context),
                      color: AppColors.white,
                    ),
                    onTap: () {
                      context.pushNamed(AppRoutes.runnersScreen.name);
                      provider.getUpcomingRunner(onSuccess: () {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
