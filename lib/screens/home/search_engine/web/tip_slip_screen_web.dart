import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';

class TipSlipScreenWeb extends StatelessWidget {
  const TipSlipScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyWidth = context.isBrowserMobile
        ? double.maxFinite
        : context.isTablet
        ? 1000.w
        : 900.w;
    // final twentyResponsive = context.isDesktop
    //     ? 20.sp
    //     : context.isTablet
    //     ? 28.sp
    //     : (context.isBrowserMobile)
    //     ? 36.sp
    //     : 20.sp;

    final sixteenResponsive = context.isDesktop
        ? 16.sp
        : context.isTablet
        ? 24.sp
        : (context.isBrowserMobile)
        ? 32.sp
        : 16.sp;

    final fourteenResponsive = context.isDesktop
        ? 14.sp
        : context.isTablet
        ? 22.sp
        : (context.isBrowserMobile)
        ? 30.sp
        : 14.sp;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: bodyWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  topBar(
                    context: context,
                    sixteenResponsive: sixteenResponsive,
                  ),

                  tipSlipItem(
                    sixteenResponsive: sixteenResponsive,
                    context: context,
                  ),
                  tipSlipItem(
                    sixteenResponsive: sixteenResponsive,
                    context: context,
                  ),
                  tipSlipItem(
                    sixteenResponsive: sixteenResponsive,
                    context: context,
                  ),
                  tipSlipItem(
                    sixteenResponsive: sixteenResponsive,
                    context: context,
                  ),
                  200.h.verticalSpace,
                  AppFilledButton(
                    isExpand: !context.isBrowserMobile ? false : true,
                    margin: EdgeInsets.symmetric(
                      horizontal: (!context.isMobileView)
                          ? 0
                          : (context.isBrowserMobile)
                          ? 35.w
                          : 25.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: context.isDesktop
                          ? 20.w
                          : context.isTablet
                          ? 28.w
                          : 0,
                    ),
                    textStyle: semiBold(
                      color: AppColors.white,
                      fontSize: fourteenResponsive,
                    ),
                    text: "Take to Bookmaker",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          //todo askPuntGPT button website
          Align(
            alignment: Alignment.bottomRight,
            child: askPuntGPTButtonWeb(context: context),
          ),
        ],
      ),
    );
  }

  Widget topBar({
    required BuildContext context,
    required double sixteenResponsive,
  }) {
    double horizontalPadding = (!context.isMobileView)
        ? 0
        : (context.isBrowserMobile)
        ? 35.w
        : 25.w;
    double topPadding = (kIsWeb && !context.isMobileView) ? 70.h : 22.h;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: 22.h,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Row(
            spacing: context.isDesktop
                ? 14.w
                : context.isTablet
                ? 22.w
                : (context.isBrowserMobile)
                ? 26.w
                : 14.w,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: (!context.isBrowserMobile)
                      ? 4
                      : (context.isBrowserMobile)
                      ? 2
                      : 0,
                ),
                child: OnMouseTap(
                  onTap: () {
                    WebRouter.indexedStackNavigationShell!.goBranch(2);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: context.isDesktop
                        ? 16.w
                        : context.isTablet
                        ? 25.w
                        : (context.isBrowserMobile)
                        ? 40.w
                        : 18.w,
                  ),
                ),
              ),
              Text(
                "Tip Slip",
                style: regular(
                  fontSize: context.isDesktop
                      ? 24.sp
                      : context.isTablet
                      ? 38.sp
                      : (context.isBrowserMobile)
                      ? 50.sp
                      : 24.sp,
                  fontFamily: AppFontFamily.secondary,
                  height: 1.35,
                ),
              ),
              25.h.verticalSpace,
            ],
          ),
        ),
        horizontalDivider(),
        24.h.verticalSpace,
      ],
    );
  }

  Widget tipSlipItem({
    required double sixteenResponsive,
    required BuildContext context,
  }) {
    double horizontalPadding = (!context.isMobileView)
        ? 0
        : (context.isBrowserMobile)
        ? 35.w
        : 25.w;
    return Container(
      margin: EdgeInsets.only(
        bottom: 8.h,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      padding: EdgeInsets.symmetric(
        vertical: context.isDesktop
            ? 12.h
            : context.isTablet
            ? 10.h
            : 8.h,
        horizontal: context.isDesktop
            ? 12.w
            : context.isTablet
            ? 18.w
            : (context.isBrowserMobile)
            ? 24.w
            : 12.w,
      ),

      decoration: BoxDecoration(border: Border.all(color: AppColors.primary)),
      child: Row(
        children: [
          //todo -----------> check box
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.only(
              right: (context.isDesktop)
                  ? 16.w
                  : (context.isTablet)
                  ? 18.w
                  : 20.w,
            ),
            curve: Curves.easeInOut,

            width: (context.isDesktop)
                ? 24.w
                : context.isTablet
                ? 32.w
                : (context.isBrowserMobile)
                ? 38.w
                : 24.w,
            height: (context.isDesktop)
                ? 24.w
                : context.isTablet
                ? 32.w
                : (context.isBrowserMobile)
                ? 38.w
                : 24.w,
            // width: (kIsWeb) ? 40.w : 22.w,
            // height: (kIsWeb) ? 40.w : 22.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: AppColors.primary,
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: context.isDesktop
                  ? 17.w
                  : context.isTablet
                  ? 25.w
                  : (context.isBrowserMobile)
                  ? 33.sp
                  : 17.sp,
            ),
          ),

          // 15.w.horizontalSpace,
          //todo -----------> title
          Text("8. Delicacy", style: semiBold(fontSize: sixteenResponsive)),
          10.horizontalSpace,
          Icon(Icons.keyboard_arrow_down_rounded),
          Spacer(),
          Text("\$8.50", style: bold(fontSize: sixteenResponsive)),
        ],
      ),
    );
  }
}
