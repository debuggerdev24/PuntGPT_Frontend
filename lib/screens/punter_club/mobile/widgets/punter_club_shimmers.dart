import 'package:puntgpt_nick/core/app_imports.dart';

class PunterClubShimmers {
  // Shimmer for the Punter Club screen. Matches layout: top bar ("Your Punters Clubs:"
  /// + icons), divider, list of club rows, divider, empty area, and "Ask @ PuntGPT" FAB.
  static Widget punterClubScreenShimmer({required BuildContext context}) {
    final horizontalPadding = (context.isBrowserMobile) ? 35.w : 25.w;
    final listHorizontalPadding = 25.w;
    final listVerticalPadding = 20.h;

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top bar: group icon + title + bell + add
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 22.h,
            ),
            child: Row(
              children: [
                Container(
                  height: (context.isBrowserMobile) ? 42.w : 28.h,
                  width: (context.isBrowserMobile) ? 42.w : 28.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: (context.isBrowserMobile) ? 60.w : 12.w),
                Expanded(
                  child: Container(
                    height: (context.isBrowserMobile) ? 32.h : 22.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  height: 28,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  height: 28,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          horizontalDivider(),

          // Club list items (alternating like real UI)
          ...List.generate(5, (index) {
            final isAlternate = index % 2 == 1;
            return Container(
              decoration: BoxDecoration(
                color: isAlternate
                    ? AppColors.shimmerBaseColor.withValues(alpha: 0.4)
                    : null,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: listHorizontalPadding,
                vertical: listVerticalPadding,
              ),
              child: Row(
                children: [
                  Container(
                    height: (context.isBrowserMobile) ? 28.h : 18.h,
                    width: (context.isBrowserMobile) ? 180.w : 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          }),

          horizontalDivider(),

          const Spacer(),

          // Bottom: "Ask @ PuntGPT" FAB placeholder
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: Container(
                height: 48.h,
                width: (context.isBrowserMobile) ? 220.w : 160.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.shimmerBaseColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget notificationSheetShimmer({required BuildContext context}) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        children: [
          // Title shimmer
          Container(
            margin: EdgeInsets.only(top: 8.h),
            height: 24.h,
            width: 160.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          16.h.verticalSpace,
          horizontalDivider(),
          // Body shimmer (notification list)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  19.h.verticalSpace,
                  ...List.generate(
                    3,
                    (_) => _notificationBoxShimmer(context),
                  ),
                ],
              ),
            ),
          ),
          // Clear all button shimmer
          SafeArea(
            child: Container(
              margin: EdgeInsets.fromLTRB(25.w, 10.w, 25.w, 18.w),
              height: 48.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.redButton.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _notificationBoxShimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left icon shimmer
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              height: 24.w,
              width: 24.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text lines shimmer
                Container(
                  height: 16.h,
                  width: (context.isBrowserMobile) ? 260.w : 180.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 16.h,
                  width: (context.isBrowserMobile) ? 220.w : 150.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Buttons row shimmer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 32.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      height: 32.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 16.w,
                      width: 16.w,
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
        ],
      ),
    );
  }

  /// Shimmer for the Invite Users bottom sheet. Matches layout: back arrow,
  /// "Invite Users" title, divider, search bar, and repeating user rows
  /// (avatar + username + invite button).
  static Widget inviteUserSheetShimmer({required BuildContext context}) {
    final userHeight = (context.isBrowserMobile) ? 96.w : 48.w;
    final userWidth = (context.isBrowserMobile) ? 68.w : 48.w;

    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 5, 25.w, 25.w),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder (centered visually; back arrow in stack)
                Container(
                  height: 24.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                20.h.verticalSpace,
                horizontalDivider(opacity: 0.65),
                20.h.verticalSpace,
                // Search bar placeholder
                Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                22.w.verticalSpace,
                // User list placeholders
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        10,
                        (_) => _inviteUserRowShimmer(
                          context: context,
                          userHeight: userHeight,
                          userWidth: userWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Back arrow placeholder
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 24.w,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _inviteUserRowShimmer({
    required BuildContext context,
    required double userHeight,
    required double userWidth,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 8.w),
      height: userHeight,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            height: userHeight,
            width: userWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: (context.isBrowserMobile) ? 80.w : 15.w),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Container(
            height: userHeight,
            width: userWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Shimmer for the Club Chat screen. Matches layout: header (back + group name +
  /// member count + icons), message list (left-aligned @username + timestamp +
  /// content bubbles), and input bar (divider + text field + send button).
  /// Display until chat history is loaded and socket is connected.
  static Widget clubChatScreenShimmer({required BuildContext context}) {
    final horizontalPadding = (context.isBrowserMobile) ? 35.w : 25.w;
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        children: [
          // Header: back arrow, group name, member count, add icon, info icon
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 16.w, horizontalPadding, 7.w),
            child: Row(
              children: [
                Container(
                  height: 16.h.flexClamp(16, 24),
                  width: 20.w,
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
                      height: (context.isBrowserMobile) ? 28.h : 18.h,
                      width: (context.isBrowserMobile) ? 120.w : 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: (context.isBrowserMobile) ? 18.h : 12.h,
                      width: (context.isBrowserMobile) ? 100.w : 60.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: (context.isBrowserMobile) ? 28.w : 22.w,
                  width: (context.isBrowserMobile) ? 28.w : 22.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: (context.isBrowserMobile) ? 20.w : 12.w),
                Container(
                  height: (context.isBrowserMobile) ? 28.w : 22.w,
                  width: (context.isBrowserMobile) ? 28.w : 22.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          horizontalDivider(),
          // Message list area: multiple message placeholders
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 100.h, left: 0, right: 0, top: 8.h),
              children: [
                _clubChatMessageShimmer(context, 0.35),
                _clubChatMessageShimmer(context, 0.55),
                _clubChatMessageShimmer(context, 0.25),
                _clubChatMessageShimmer(context, 0.75),
                _clubChatMessageShimmer(context, 0.4),
                _clubChatMessageShimmer(context, 0.6),
                _clubChatMessageShimmer(context, 0.3),
              ],
            ),
          ),
          // Input bar: divider + text field + send button
          horizontalDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: (context.isBrowserMobile) ? 56.h : 44.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.shimmerBaseColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  height: (context.isBrowserMobile) ? 44.w : 36.w,
                  width: (context.isBrowserMobile) ? 44.w : 36.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _clubChatMessageShimmer(BuildContext context, double widthFraction) {
    final msgPadding = (context.isBrowserMobile) ? 35.w : 25.w;
    return Padding(
      padding: EdgeInsets.fromLTRB(msgPadding, 12.h, 25.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: (context.isBrowserMobile) ? 20.h : 16.h,
                width: (context.isBrowserMobile) ? 100.w : 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                height: (context.isBrowserMobile) ? 18.h : 14.h,
                width: (context.isBrowserMobile) ? 70.w : 50.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          6.h.verticalSpace,
          Container(
            height: (context.isBrowserMobile) ? 20.h : 16.h,
            width: MediaQuery.sizeOf(context).width * widthFraction,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          12.h.verticalSpace,
          horizontalDivider(),
        ],
      ),
    );
  }

  /// Shimmer for the Group Members screen list. Matches layout: circular
  /// profile icon on the left, member name and "Joined on..." text on the right,
  /// with separators between rows.
  static Widget groupMembersScreenShimmer({required BuildContext context}) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Padding(
        padding: EdgeInsets.only(top: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(10, (index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 16.h),
                    child: Row(
                      children: [
                        Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Container(
                                height: 16.h,
                                width: (context.isBrowserMobile) ? 160.w : 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 14.h,
                                width: (context.isBrowserMobile) ? 220.w : 180.w,
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
                  horizontalDivider(),
                ],
              );
            }),
        ),
      ),
    );
  }
}
