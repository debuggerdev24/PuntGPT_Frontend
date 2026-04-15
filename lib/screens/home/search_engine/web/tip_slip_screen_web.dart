import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/home_screen_web.dart';

class TipSlipScreenWeb extends StatelessWidget {
  const TipSlipScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    // final bodyWidth = context.isBrowserMobile
    //     ? double.maxFinite
    //     : 700;
    // final twentyResponsive = context.isDesktop
    //     ? 20.sp
    //     : context.isTablet
    //     ? 28.sp
    //     : (context.isBrowserMobile)
    //     ? 36.sp
    //     : 20.sp;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: (context.isMobileView) ? 0 : (context.isTablet) ? 100 : 200),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                topBar(
                  context: context,
                ),
            
                tipSlipItem(
                  context: context,
                ),
                tipSlipItem(
                  context: context,
                ),
                tipSlipItem(
                  context: context,
                ),
                tipSlipItem(
                  context: context,
                ),
               SizedBox(height: 60),
              ],
            ),
          ),
          //* askPuntGPT button website
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

  }) {
    double horizontalPadding = (!context.isMobileView)
        ? 0
        : 18;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: (!context.isMobileView) ? 75 : 13,
            bottom: 14,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Row(
            spacing: 14,
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
                    size: 14,
                  ),
                ),
              ),
              Text(
                "Tip Slip",
                style: regular(
                  fontSize: 22,
                  fontFamily: AppFontFamily.secondary,
                  height: 1,
                ),
              ),
              SizedBox(width: 25),
            ],
          ),
        ),
        horizontalDivider(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget tipSlipItem({
    required BuildContext context,
  }) {
    double horizontalPadding = (!context.isMobileView)
        ? 0
        : 20;
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),

      decoration: BoxDecoration(border: Border.all(color: AppColors.primary)),
      child: Row(
        children: [
          //* -----------> check box
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.only(
              right: 16,
            ),
            curve: Curves.easeInOut,

            width: 22,
            height: 22,
            // width: (kIsWeb) ? 40.w : 22.w,
            // height: (kIsWeb) ? 40.w : 22.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: AppColors.primary,
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          // 15.w.horizontalSpace,
          //* -----------> title
          Text("8. Delicacy", style: semiBold(fontSize: 15)),
          SizedBox(width: 10),
          Icon(Icons.keyboard_arrow_down_rounded),
          Spacer(),
          Text("\$8.50", style: bold(fontSize: 15)),
        ],
      ),
    );
  }
}
