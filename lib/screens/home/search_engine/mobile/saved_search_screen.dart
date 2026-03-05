import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/search_model.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/provider/subscription/subscription_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class SavedSearchScreen extends StatefulWidget {
  const SavedSearchScreen({super.key});

  @override
  State<SavedSearchScreen> createState() => _SavedSearchScreenState();
}

class _SavedSearchScreenState extends State<SavedSearchScreen> {
  @override
  Widget build(BuildContext context) {
    if (!context.isMobileView) {
      context.pop();
    }
    return Consumer2<SearchEngineProvider, SubscriptionProvider>(
      builder: (context, provider, subProvider, child) => Column(
        children: [
          _buildTopBar(context, isSubscribed: subProvider.isSubscribed),
          horizontalDivider(),
          Expanded(
            child: subProvider.isSubscribed
                ? _buildSubscriberContent(context, provider)
                : _buildNonSubscriberContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, {required bool isSubscribed}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 6.w, 0.w, 6.w),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_rounded, size: 16.w),
          ),
          Text(
            "Saved Searches",
            style: TextStyle(
              fontFamily: AppFontFamily.secondary,
              fontSize: (context.isBrowserMobile) ? 50.sp : 24.sp,
            ),
          ),
          if (!isSubscribed) ...[
            12.w.horizontalSpace,
            GestureDetector(
              onTap: () {
                context.pushNamed(
                  (kIsWeb && context.isMobileView)
                      ? WebRoutes.manageSubscriptionScreen.name
                      : AppRoutes.manageSubscriptionScreen.name,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColors.premiumYellow.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.premiumYellow),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "Upgrade to Pro",
                  style: bold(
                    fontSize: 14.fourteenSp(context),
                    color: AppColors.premiumYellow,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubscriberContent(
    BuildContext context,
    SearchEngineProvider provider,
  ) {
    if (provider.saveSearches == null) {
      return ListView(
        padding: EdgeInsets.zero,
        children: List.generate(
          5,
          (index) => HomeSectionShimmers.searchedItemShimmer(context: context),
        ),
      );
    }
    if (provider.saveSearches!.isEmpty) {
      return _buildEmptyState(context);
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: provider.saveSearches!.length,
      itemBuilder: (context, index) => SearchedItem(
        search: provider.saveSearches![index],
        onTap: () => provider.getSaveSearchDetails(
          id: provider.saveSearches![index].id.toString(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all((context.isBrowserMobile) ? 28.w : 22.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.bookmark_border_rounded,
                size: (context.isBrowserMobile) ? 64.sp : 48.sp,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            24.h.verticalSpace,
            Text(
              "No saved searches yet",
              style: semiBold(
                fontSize: (context.isBrowserMobile) ? 28.sp : 18.sp,
                fontFamily: AppFontFamily.secondary,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            12.h.verticalSpace,
            Text(
              "Save your favourite filters from the Search Engine so they’re ready every time you open the app.",
              style: regular(
                fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            28.h.verticalSpace,
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: Icon(Icons.search_rounded, size: 20.sp),
              label: Text(
                "Go to Search Engine",
                style: semiBold(fontSize: 14.sp, color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<({String name, String comment})> _staticPlaceholders = [
    (name: "Favourites", comment: "e.g. Top picks • Randwick • 1200m"),
    (name: "Heavy track", comment: "Wet conditions • Soft 7+"),
    (name: "Roughies", comment: "Long odds • value systems"),
  ];

  Widget _buildNonSubscriberContent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(25.w, 16.h, 25.w, 24.h),
      children: [
        ..._staticPlaceholders.map(
          (p) =>
              _StaticSavedSearchPlaceholder(name: p.name, comment: p.comment),
        ),
        20.w.verticalSpace,
        _buildUpgradeCard(context),
      ],
    );
  }

  Widget _buildUpgradeCard(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all((context.isBrowserMobile) ? 24.w : 20.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.premiumYellow.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 24.sp,
                  color: AppColors.premiumYellow,
                ),
              ),
              12.w.horizontalSpace,
              Expanded(
                child: Text(
                  "Upgrade to Pro Punter to save your custom searches",
                  style: semiBold(
                    fontSize: (context.isBrowserMobile) ? 26.sp : 15.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          16.h.verticalSpace,
          _bullet(
            context,
            "Have your form done and ready each time you open the app.",
          ),
          8.h.verticalSpace,
          _bullet(
            context,
            "Have one for favourites, one for Roughies, one for heavy track conditions, or any system you think’s a winner!",
          ),
          20.h.verticalSpace,
          SizedBox(
            width: double.maxFinite,
            child: AppFilledButton(
              onTap: () {
                context.pushNamed(
                  (kIsWeb && context.isMobileView)
                      ? WebRoutes.manageSubscriptionScreen.name
                      : AppRoutes.manageSubscriptionScreen.name,
                );
              },
              text: "Upgrade to Pro",
              textStyle: semiBold(
                fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
                color: AppColors.white,
              ),
              color: AppColors.premiumYellow,
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "• ",
          style: medium(
            fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
            color: AppColors.primary.withValues(alpha: 0.7),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: regular(
              fontSize: (context.isBrowserMobile) ? 24.sp : 14.sp,
              color: AppColors.primary.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _StaticSavedSearchPlaceholder extends StatelessWidget {
  const _StaticSavedSearchPlaceholder({
    required this.name,
    required this.comment,
  });

  final String name;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (context.isBrowserMobile) ? 10.w : 0,
        vertical: (context.isBrowserMobile) ? 20.w : 12.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: (context.isBrowserMobile) ? 32.sp : 18.sp,
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
            12.w.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 36.sp : 18.sp,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  4.h.verticalSpace,
                  Text(
                    comment,
                    style: regular(
                      fontSize: (context.isBrowserMobile) ? 26.sp : 13.sp,
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: (context.isBrowserMobile) ? 28.w : 14.w,
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchedItem extends StatelessWidget {
  const SearchedItem({super.key, required this.search, required this.onTap});
  final SaveSearchModel search;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (context.isBrowserMobile) ? 35.w : 25.w,
        vertical: (context.isBrowserMobile) ? 24.w : 14.h,
      ),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(AppRoutes.searchDetails.name);
          onTap.call();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    search.name,
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 40.sp : 20.sp,
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                  ),
                  Text(
                    DateFormatter.formatDateLong(search.createdAt),
                    style: semiBold(
                      fontSize: (context.isBrowserMobile) ? 30.sp : 12.sp,
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  6.5.h.verticalSpace,
                  Text(
                    search.comment,
                    style: regular(
                      fontSize: (context.isBrowserMobile) ? 40.sp : 20.sp,
                      color: AppColors.primary.withValues(alpha: 0.27),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.black,
              size: (context.isBrowserMobile) ? 40.w : 14.w,
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:puntgpt_nick/core/app_imports.dart';
// import 'package:puntgpt_nick/models/home/search_engine/search_model.dart';
// import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';

// import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

// class SavedSearchScreen extends StatelessWidget {
//   const SavedSearchScreen({super.key});






//   @override
//   Widget build(BuildContext context) {
//     if (!context.isMobileView) {
//       context.pop();
//     }
//     return Consumer<SearchEngineProvider>(
//       builder: (context, provider, child) => Column(
//         children: [
//           topBar(context: context),
//           horizontalDivider(),
//           // Consumer<SearchEngineProvider>(
//           //   builder: (context, provider, child) =>
//           // ),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 20.h.verticalSpace,
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25.w),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Upgrade to Pro Punter to save your custom Searches.",
//                         style: bold(fontSize: 16.sixteenSp(context)),
//                       ),
//                       16.h.verticalSpace,
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("• ", style: medium(fontSize: 14.sp)),
//                           Expanded(
//                             child: Text(
//                               "Have your form done and ready each time you open the app.",
//                               style: medium(fontSize: 14.fourteenSp(context)),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "• ",
//                             style: medium(fontSize: 14.fourteenSp(context)),
//                           ),
//                           Expanded(
//                             child: Text(
//                               "Have one for favorite's, one for Roughies, one for heavy track conditions, or any system you thinks a winner!",
//                               style: medium(fontSize: 14.fourteenSp(context)),
//                             ),
//                           ),
//                         ],
//                       ),
//                       32.h.verticalSpace,
//                     ],
//                   ),
//                 ),

//                 if (provider.saveSearches == null)
//                   ...List.generate(
//                     5,
//                     (index) => HomeSectionShimmers.searchedItemShimmer(context: context,),
//                   ),
//                 if (provider.saveSearches != null) ...[
//                   ...List.generate(
//                     provider.saveSearches!.length,
//                     (index) => SearchedItem(
//                       search: provider.saveSearches![index],
//                       onTap: () => provider.getSaveSearchDetails(
//                         id: provider.saveSearches![index].id.toString(),
//                       ),
//                     ),
//                   ),

//                   //provider.saveSearches!.map((e) => ),
//                 ],
//               ],
//             ),
//           ),
//           // horizontalDivider(),

//           // AppFilledButton(
//           //   margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.w),
//           //   text: "Save Current Search",
//           //   textStyle: semiBold(
//           //     fontSize: 16.sixteenSp(context),
//           //     color: AppColors.white,
//           //   ),
//           //   onTap: () {},
//           // ),
        
//         ],
//       ),
//     );
//   }

//   Widget topBar({required BuildContext context}) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(
//         (context.isBrowserMobile) ? 35.w : 25.w,
//         16.h,
//         (context.isBrowserMobile) ? 33.w : 23.w,
//         16.h,
//       ),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [







//           Text(
//             "Saved Searches",
//             style: TextStyle(
//               fontFamily: AppFontFamily.secondary,
//               fontSize: (context.isBrowserMobile) ? 50.sp : 24.sp,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               AppRouter.indexedStackNavigationShell!.goBranch(3);
//             },
//             child: Container(
//               margin: EdgeInsets.only(left: 12.w),
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7.h),






























































//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.premiumYellow),





//               ),
//               child: Text(
//                 "Upgrade to Pro",
//                 style: bold(
//                   fontSize: 14.fourteenSp(context),
//                   color: AppColors.premiumYellow,




































//                 ),
//               ),
//             ),































































//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               context.pop();
//             },
//             child: Icon(Icons.close_rounded),























//           ),
//         ],
//       ),
//     );
//   }




























































































// }

// class SearchedItem extends StatelessWidget {
//   const SearchedItem({super.key, required this.search, required this.onTap});
//   final SaveSearchModel search;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
// @@ -172,34 +386,36 @@ class SearchedItem extends StatelessWidget {
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   search.name,
//                   style: semiBold(
//                     fontSize: (context.isBrowserMobile) ? 40.sp : 20.sp,
//                     color: AppColors.primary.withValues(alpha: 0.35),


//                   ),
//                 ),
//                 Text(
//                   // "Sep 30, 2025"
//                   DateFormatter.formatDateLong(search.createdAt),
//                   style: semiBold(
//                     fontSize: (context.isBrowserMobile) ? 30.sp : 12.sp,
//                     color: AppColors.primary.withValues(alpha: 0.2),
//                   ),
//                 ),
//                 6.5.h.verticalSpace,
//                 Text(
//                   search.comment,
//                   // "Randwick • 1200m • >20%",
//                   style: regular(
//                     fontSize: (context.isBrowserMobile) ? 40.sp : 20.sp,
//                     color: AppColors.primary.withValues(alpha: 0.27),

//                   ),
//                 ),
//               ],
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded