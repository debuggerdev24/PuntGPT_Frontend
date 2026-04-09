import 'package:puntgpt_nick/core/app_imports.dart';

class HomeSectionShimmers {
  HomeSectionShimmers._();

  /// Shimmer for the Search Detail screen (home_screen)
  static Widget homeScreenShimmer({required BuildContext context}) {
    final bodyPad = (context.isBrowserMobile) ? 50.w : 25.w;
    const storyPad = 18.0;
    const tabPad = 20.0;
    final isWide = context.isBrowserMobile;

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bookie stories: banner + three circular avatars
          Padding(
            padding: EdgeInsets.symmetric(horizontal: storyPad.w),
            child: Column(
              children: [
                5.w.verticalSpace,
                Center(
                  child: Container(
                    width: isWide ? 420.w : 280.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                12.w.verticalSpace,
                SizedBox(
                  height: 64.w,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: 3,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemBuilder: (_, __) => Container(
                      width: 64.w,
                      height: 64.w,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.shimmerBaseColor.withValues(
                            alpha: 0.45,
                          ),
                        ),
                      ),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // HomeScreenTab: two equal tabs
          Padding(
            padding: EdgeInsets.fromLTRB(tabPad.w, 14.w, tabPad.w, 0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: isWide ? 72.h : 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.primary),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: isWide ? 72.h : 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          16.w.verticalSpace,

          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 100.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tagline row + Saved Searches
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          bodyPad,
                          0,
                          bodyPad,
                          14.w,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: isWide ? 28.h : 18.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            10.w.horizontalSpace,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 16.w,
                                  height: 16.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                6.w.horizontalSpace,
                                Container(
                                  width: 110.w,
                                  height: 14.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Race timing chips (horizontal)
                      SizedBox(
                        height: 45.w.flexClamp(40, 55),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: bodyPad),
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 15),
                          itemBuilder: (_, i) {
                            final w = i == 0 ? 115.w : (i == 1 ? 145.w : 100.w);
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 10.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: w,
                                height: 16.h,
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: bodyPad),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 18.w),
                              child: horizontalDivider(),
                            ),
                            // All Tracks dropdown
                            Container(
                              margin: EdgeInsets.only(bottom: 18.w),
                              height: isWide ? 56.h : 46.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: AppColors.shimmerBaseColor,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 120.w,
                                    height: 16.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            horizontalDivider(),
                            ...List.generate(6, (index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 19.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: isWide ? 220.w : 160.w,
                                          height: isWide ? 22.h : 18.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  horizontalDivider(),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),

                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 24.w,
                            right: 24.w,
                            top: 20.w,
                          ),
                          height: 48.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 18.w,
                  bottom: 18.w,
                  child: Container(
                    width: 140.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.22),
                      ),
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

  static Widget searchedItemShimmer({required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: (context.isBrowserMobile) ? 35.w : 25.w,
      vertical: (context.isBrowserMobile) ? 24.w : 14.h,
    ),
    child: Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Container(
                width: (context.isBrowserMobile) ? 200.w : 100.w,
                height: (context.isBrowserMobile) ? 40.h : 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 6.5.h),
              // Date shimmer
              Container(
                width: (context.isBrowserMobile) ? 150.w : 80.w,
                height: (context.isBrowserMobile) ? 30.h : 12.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 6.5.h),
              // Description shimmer
              Container(
                width: (context.isBrowserMobile) ? 350.w : 180.w,
                height: (context.isBrowserMobile) ? 40.h : 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          // Arrow icon shimmer
          Container(
            width: (context.isBrowserMobile) ? 40.w : 14.w,
            height: (context.isBrowserMobile) ? 40.w : 14.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    ),
  );
  }

  /// Shimmer for the Search Detail screen (manage_saved_search)
  static Widget searchDetailShimmer({required BuildContext context}) {
  return Column(
    children: [
      // Top bar shimmer (back arrow + title + subtitle)
      Padding(
        padding: EdgeInsets.fromLTRB(5.w, 14.h, 25.w, 14.h),
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: Row(
            children: [
              24.w.horizontalSpace,
              // Back icon placeholder
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: (context.isBrowserMobile) ? 180.w : 120.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Subtitle placeholder
                  Container(
                    width: (context.isBrowserMobile) ? 220.w : 160.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Divider placeholder
      Container(height: 1, color: AppColors.shimmerBaseColor),
      // Body shimmer (track section + buttons)
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              // Track section shimmer (title + rows)
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    // "Track" title shimmer
                    Container(
                      width: 80.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Track rows shimmer
                    ...List.generate(3, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Label placeholder
                            Container(
                              width: 160.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            // Checkbox placeholder
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              // Edit button shimmer
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8.h),
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Delete button shimmer
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    ],
  );
  }

  /// Shimmer for the Selected Race screen. Matches layout: top bar, race tabs (R1–R7),
  /// sub-nav (Tips & Analysis, Speed Maps, Sectionals), and race table rows.
  static Widget selectedRaceScreenShimmer({required BuildContext context}) {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Top bar: back arrow + title + subtitle
        Padding(
          padding: EdgeInsets.fromLTRB(25.w, 16.w, 25.w, 20.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 220.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        horizontalDivider(opacity: 0.8),
        //* Race selection tabs (R1–R7)
        Container(
          margin: EdgeInsets.fromLTRB(25.w, 28.w, 25.w, 0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.shimmerBaseColor),
          ),
          child: Row(
            children: List.generate(7, (_) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),

        //* Sub-nav: Tips & Analysis | Speed Maps | Sectionals
        Container(
          margin: EdgeInsets.symmetric(vertical: 30.w, horizontal: 25.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.shimmerBaseColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (_) {
              return Container(
                width: 80.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
        //* Race table shimmer (rows matching horse list + W: J: F: T: column)
        //* Use SizedBox instead of Expanded: Expanded requires a Flex parent, but
        //* Shimmer wraps the child and breaks that ancestor chain.
        SizedBox(
          height: 320.h,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: SizedBox(
              height: 240.h,
              child: Container(
                width: 1.4.sw,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: List.generate(5, (index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.shimmerBaseColor.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Horse number + name placeholder
                          Expanded(
                            flex: 16,
                            child: Container(
                              height: 16.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // W: J: F: T: placeholder
                          Expanded(
                            flex: 30,
                            child: Container(
                              height: 14.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        // Ask @PuntGPT button placeholder
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 25.h, right: 25.w),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 48.h,
              width: 160.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  }

  /// Shimmer for the Classic Form Guide view. Matches layout: "Next to go" cards,
  /// day tabs, and race table rows.
  static Widget classicFormGuideShimmer({required BuildContext context}) {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Next to go" title shimmer
          Container(
            width: 100.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          10.verticalSpace,
          // Next to go cards shimmer (horizontal)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(2, (_) {
                return Container(
                  width: 240.w,
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 14.w, 14.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      6.w.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 120.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 40.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Days tabs shimmer
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (_) {
                return Container(
                  margin: EdgeInsets.only(top: 24.h, bottom: 16.h, right: 8.w),
                  width: 70.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Race table shimmer
          Container(
            width: 1.6.sw,
            margin: EdgeInsets.only(bottom: 55.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: List.generate(8, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.shimmerBaseColor.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Meeting name column
                      Expanded(
                        flex: 35,
                        child: Container(
                          width: 90.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          width: 20.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 30,
                        child: Container(
                          width: 70.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 30,
                        child: Container(
                          width: 40.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          25.h.verticalSpace,
        ],
      ),
    ),
  );
  }

  /// Shimmer for the Tips & Analysis screen. Matches layout: top bar (back + title +
  /// subtitle), Analysis heading + text block, Tips heading + tip cards (silks, details, odds).
  static Widget tipsAndAnalysisScreenShimmer({required BuildContext context}) {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Top bar: back arrow + title + subtitle
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 14, 25.w, 20.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 160.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    6.w.verticalSpace,
                    Container(
                      width: 220.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        horizontalDivider(opacity: 0.8),
        //* Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                28.w.verticalSpace,
                // Analysis heading
                Container(
                  width: 80.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                // Analysis text lines
                Container(
                  margin: EdgeInsets.only(top: 8.w),
                  width: double.infinity,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                Container(
                  width: 280.w,
                  height: 14.h,
                  margin: EdgeInsets.symmetric(vertical: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 8.w),

                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                30.w.verticalSpace,
                //* Tips heading
                Container(
                  width: 50.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                12.w.verticalSpace,
                // Tip cards
                ...List.generate(4, (_) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.shimmerBaseColor.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        // Silks placeholder
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: AppColors.shimmerBaseColor.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                        12.w.horizontalSpace,
                        // Horse details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              4.w.verticalSpace,
                              Container(
                                width: 100.w,
                                height: 13.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              2.w.verticalSpace,
                              Container(
                                width: 60.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Odds placeholder
                        Container(
                          width: 50.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                24.w.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    ),
  );
  }

    /// Shimmer for the Tip Slip screen. Matches layout: top bar (back + title +
  /// subtitle), list of tip slip items (chevron, silks, horse details, odds, remove),
  /// Play Fantasy Picks button, Upgrade to Pro Punter text.
  static Widget tipSlipScreenShimmer({required BuildContext context}) {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Top bar: back arrow + title + subtitle
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 25.w),
          child: Row(
            children: [
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: context.isBrowserMobile ? 120.w : 70.w,
                    height: context.isBrowserMobile ? 32.h : 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: context.isBrowserMobile ? 260.w : 180.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        horizontalDivider(opacity: 0.8),
        //* List of tip slip items
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25.w, 15.w, 25.w, 10.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 15.w),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return HomeSectionShimmers._tipSlipItemShimmer(context: context);
                    },
                  ),
                ),
                //* Play Fantasy Picks button shimmer
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 12.h),
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                //* Upgrade to Pro Punter text shimmer
                Container(
                  width: 160.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  }

  static Widget _tipSlipItemShimmer({required BuildContext context}) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
      ),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      children: [
        // Chevron shimmer
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        12.w.horizontalSpace,
        // Silks placeholder (40x40)
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: AppColors.shimmerBaseColor.withValues(alpha: 0.5),
            ),
          ),
        ),
        12.w.horizontalSpace,
        // Horse details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.isBrowserMobile ? 140.w : 100.w,
                height: context.isBrowserMobile ? 20.h : 16.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              4.h.verticalSpace,
              Container(
                width: context.isBrowserMobile ? 100.w : 80.w,
                height: context.isBrowserMobile ? 16.h : 13.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ),
        12.w.horizontalSpace,
        // Odds box shimmer
        Container(
          width: 55.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        8.w.horizontalSpace,
        // Remove button shimmer
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
      ],
    ),
  );
  }

    /// Shimmer for the Analysis and Field Comparison modal bottom sheet.
  /// Matches layout: title area, divider, body paragraph area.
  /// Height sized to fill the modal body like the actual analysis text.
  static Widget fieldComparisonShimmer({required BuildContext context}) {
  final lineHeight = 16.h;
  final lineSpacing = 6.h;
  final bodyLines = <double>[
    double.infinity,
    280.w,
    double.infinity,
    240.w,
    double.infinity,
    200.w,
    double.infinity,
    260.w,
    double.infinity,
    220.w,
    double.infinity,
    180.w,
    double.infinity,
  ];
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title shimmer - "Analysis and Field Comparison"
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 12.h),
            child: Container(
              
              width: 220.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        Divider(
          color: AppColors.primary.withValues(alpha: 0.9),
        ),
        // Body paragraph shimmer - fills modal height like actual text block
        Padding(
          padding: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < bodyLines.length; i++) ...[
                if (i > 0) SizedBox(height: lineSpacing),
                Container(
                  width: bodyLines[i],
                  height: lineHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
  }

  static Widget runnerShimmer() {
  return Column(
    children: [
      // Total Runners + Saved Searches row shimmer
      Padding(
        padding: EdgeInsets.fromLTRB(25.w, 16.w, 25.w, 16.w),
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 160.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 100.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section with checkbox, name, and odds
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 3),
                      child: Row(
                        children: [
                          // Checkbox shimmer
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ),
                          15.horizontalSpace,
                          // Race number shimmer
                          Container(
                            width: 30.w,
                            height: 18.h,
                            color: Colors.white,
                          ),
                          5.horizontalSpace,
                          // Jockey name shimmer
                          Container(
                            width: 120.w,
                            height: 18.h,
                            color: Colors.white,
                          ),
                          Spacer(),
                          // Odds shimmer
                          Container(
                            width: 60.w,
                            height: 18.h,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Divider(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      height: 1,
                    ),
                    // Date/time info row
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80.w,
                            height: 16.h,
                            color: Colors.white,
                          ),
                          Container(
                            width: 70.w,
                            height: 16.h,
                            color: Colors.white,
                          ),
                          Container(
                            width: 90.w,
                            height: 16.h,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Divider(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      height: 1,
                    ),
                    // "Odds may differ with:" text shimmer
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
                      child: Container(
                        width: 150.w,
                        height: 16.h,
                        color: Colors.white,
                      ),
                    ),
                    // Divider
                    Divider(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      height: 1,
                    ),
                    // Buttons section
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 6, 8, 16),
                      child: Row(
                        spacing: 6.w,
                        children: [
                          Expanded(
                            child: Container(height: 44.h, color: Colors.white),
                          ),
                          Expanded(
                            child: Container(height: 44.h, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
  }

    /// Shimmer for bot response loading in Ask @PuntGPT chat.
  /// Matches ChatSection layout: sender label, timestamp, content lines.
  static Widget chatMessageShimmer({required BuildContext context}) {
  final horizontalPadding = (context.isBrowserMobile) ? 35.w : 25.w;
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBaseColor,
    highlightColor: AppColors.shimmerHighlightColor,
    child: Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 12.h, 25.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: (context.isBrowserMobile) ? 120.w : 80.w,
            height: (context.isBrowserMobile) ? 32.h : 18.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            width: (context.isBrowserMobile) ? 100.w : 70.w,
            height: (context.isBrowserMobile) ? 26.h : 14.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 12.h),
          ...List.generate(
            4,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Container(
                width: i == 2 ? 200.w : double.infinity,
                height: (context.isBrowserMobile) ? 32.h : 16.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          16.h.verticalSpace,
          horizontalDivider(),
        ],
      ),
    ),
  );
  }

  //* Shimmer for Speed Maps: segmented tabs, track map, legend, runner cards.
  static Widget speedMapsScreenShimmer({required BuildContext context}) {
    final isWide = context.isBrowserMobile;
    final hPad = 16.w;
    final mapHeight = isWide ? 240.h : 200.h;
    final tabH = isWide ? 52.h : 46.h;

    Widget line(double widthFactor, double height) {
      return FractionallySizedBox(
        widthFactor: widthFactor,
        alignment: Alignment.centerLeft,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      );
    }

    final body = SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hPad, 16.h, hPad, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: mapHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: mapHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                Positioned(
                  left: 12.w,
                  top: 14.h,
                  child: Container(
                    width: isWide ? 48.w : 40.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Positioned(
                  left: 28.w,
                  top: 48.h,
                  child: Container(
                    width: 32.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Positioned(
                  right: 36.w,
                  top: 72.h,
                  child: Container(
                    width: 28.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Positioned(
                  left: 52.w,
                  bottom: 40.h,
                  child: Container(
                    width: 36.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Positioned(
                  right: 20.w,
                  top: 36.h,
                  child: Container(
                    width: 30.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          24.h.verticalSpace,
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: List.generate(
              5,
              (_) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                  6.w.horizontalSpace,
                  Container(
                    width: isWide ? 72.w : 56.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          24.h.verticalSpace,
          ...List.generate(
            4,
            (_) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  12.w.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        line(0.92, isWide ? 18.h : 14.h),
                        8.h.verticalSpace,
                        line(0.55, isWide ? 16.h : 12.h),
                        8.h.verticalSpace,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: isWide ? 100.w : 80.w,
                            height: isWide ? 22.h : 18.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.w.horizontalSpace,
                  Container(
                    width: isWide ? 72.w : 64.w,
                    height: isWide ? 40.h : 36.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hPad.horizontalSpace,
            GestureDetector(
              onTap: () => context.pop(),
              child: Padding(
                padding: EdgeInsets.only(top: 14.w),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 16.w,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.shimmerHighlightColor,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 12.w, 16.w, 12.w),
                  child: Container(
                    height: tabH,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: body,
          ),
        ),
      ],
    );
  }
}
