import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_screen_tab.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_screen_tab_web.dart';

class SelectedRaceTableScreenWeb extends StatefulWidget {
  const SelectedRaceTableScreenWeb({super.key});

  @override
  State<SelectedRaceTableScreenWeb> createState() =>
      _SelectedRaceTableScreenWebState();
}

class _SelectedRaceTableScreenWebState
    extends State<SelectedRaceTableScreenWeb> {
  String selItem = "R1";

  @override
  Widget build(BuildContext context) {
    final bodyWidth = context.isBrowserMobile
        ? 1.4.sw
        : context.isTablet
        ? 1100.w
        : 1000.w;

    final sixteenResponsive = context.isDesktop
        ? 16.sp
        : context.isTablet
        ? 24.sp
        : (context.isBrowserMobile)
        ? 32.sp
        : 16.sp;
    final eighteenResponsive = context.isDesktop
        ? 18.sp
        : context.isTablet
        ? 26.sp
        : (context.isBrowserMobile)
        ? 34.sp
        : 16.sp;
    final fourteenResponsive = context.isDesktop
        ? 14.sp
        : context.isTablet
        ? 22.sp
        : (context.isBrowserMobile)
        ? 26.sp
        : 14.sp;
    return Scaffold(
      body: Align(
        alignment: (kIsWeb && !context.isMobileView)
            ? Alignment.center
            : Alignment.centerLeft,
        child: Consumer<SearchEngineProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              width: bodyWidth,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (context.isBrowserMobile) ? 55.w : 25.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kIsWeb && !context.isMobileView) ...[
                      70.h.verticalSpace,

                      HomeScreenTabWeb(
                        selectedIndex: provider.selectedTab,
                        onTap: () {
                          context.pop();
                        },
                      ),
                    ] else ...[
                      20.h.verticalSpace,
                      HomeScreenTab(
                        selectedIndex: provider.selectedTab,
                        onTap: () {
                          context.pop();
                        },
                      ),
                    ],

                    //todo top bar
                    topBar(
                      context: context,
                      sixteenResponsive: sixteenResponsive,
                      eighteenResponsive: eighteenResponsive,
                    ),
                    //todo drop down
                    SizedBox(
                      width: 290.w,
                      child: Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: OnMouseTap(
                            child: AppTextFieldDropdown(
                              textStyle: medium(fontSize: fourteenResponsive),
                              items: List.generate(10, (index) {
                                return "R ${index + 1}";
                              }),
                              selectedValue: selItem,
                              onChange: (value) {
                                setState(() {
                                  selItem = value;
                                });
                              },

                              hintText: "R1",
                            ),
                          ),
                        ),
                      ),
                    ),

                    SelectedRaceTableWeb(
                      bodyWidth: bodyWidth,
                      sixteenResponsive: sixteenResponsive,
                      fourteenResponsive: fourteenResponsive,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //todo top bar
  Widget topBar({
    required BuildContext context,
    required double sixteenResponsive,
    required double eighteenResponsive,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 25.w),
          child: Row(
            spacing: eighteenResponsive,

            children: [
              OnMouseTap(
                onTap: () {
                  context.pop();
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 16.h),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flemington",
                    style: regular(
                      fontSize: context.isDesktop
                          ? 20.sp
                          : context.isTablet
                          ? 28.sp
                          : (context.isBrowserMobile)
                          ? 36.sp
                          : 20.sp,
                      fontFamily: AppFontFamily.secondary,
                      height: 1.35,
                    ),
                  ),
                  Text(
                    "PuntGPT Legends Stakes 3200m. Date. Time",
                    style: semiBold(
                      fontSize: context.isDesktop
                          ? 12.sp
                          : context.isTablet
                          ? 20.sp
                          : (context.isBrowserMobile)
                          ? 24.sp
                          : 12.sp,
                      color: AppColors.greyColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        horizontalDivider(),
      ],
    );
  }
}

class SelectedRaceTableWeb extends StatefulWidget {
  const SelectedRaceTableWeb({
    super.key,
    required this.bodyWidth,
    required this.sixteenResponsive,
    required this.fourteenResponsive,
  });

  final double bodyWidth;
  final double sixteenResponsive, fourteenResponsive;

  @override
  State<SelectedRaceTableWeb> createState() => _SelectedRaceTableWebState();
}

class _SelectedRaceTableWebState extends State<SelectedRaceTableWeb> {
  int? expandedIndex;

  final List<Map<String, String>> horses = [
    {"name": "Prince of Penzance"},
    {"name": "Makybe Diva"},
    {"name": "Fiorente"},
    {"name": "Gold Trip"},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(top: 24.h, bottom: 55.h),
        width: widget.bodyWidth,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          columnWidths: {0: FlexColumnWidth(1.1.w), 1: FlexColumnWidth(3.w)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: List.generate(horses.length, (index) {
            final isExpanded = expandedIndex == index;
            return TableRow(
              decoration: BoxDecoration(),
              children: [
                IntrinsicHeight(
                  child: OnMouseTap(
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded ? null : index;
                      });
                    },
                    child: Container(
                      color: isExpanded
                          ? AppColors.primary
                          : Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 16.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ${horses[index]["name"]!}",
                              style: semiBold(
                                fontSize: widget.sixteenResponsive,
                                color: isExpanded ? Colors.white : null,
                              ),
                            ),
                            if (isExpanded) ...[
                              12.h.verticalSpace,
                              Text(
                                "\$2.10",
                                style: semiBold(
                                  fontSize: widget.sixteenResponsive,
                                  color: Colors.white,
                                ),
                              ),
                              AppFilledButton(
                                margin: EdgeInsets.only(top: 4),
                                text: "Add to Tip Slip",
                                textStyle: semiBold(
                                  fontSize: widget.fourteenResponsive,
                                  color: AppColors.primary,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 9.h),
                                color: AppColors.white,

                                onTap: () {},
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 12.w,
                  ),
                  child: isExpanded
                      ? Align(
                          alignment: AlignmentGeometry.topLeft,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            runSpacing: 14.h,
                            spacing: 12.w,
                            children: [
                              ...[
                                "Weight",
                                "Jockey",
                                "Form",
                                "Trainer",
                                "Career",
                                "Track",
                                "Distance",
                                "1st up",
                                "2nd up",
                                "3rd up",
                                "Firm",
                                "Soft",
                                "Heavy",
                              ].map(
                                (label) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      label,
                                      style: medium(
                                        fontSize: widget.fourteenResponsive,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    VerticalDivider(color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          "W: J: F: T:",
                          style: medium(
                            fontSize: widget.fourteenResponsive,
                            color: AppColors.primary,
                          ),
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Widget _buildDetailBox(String label) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
  //       borderRadius: BorderRadius.circular(6.r),
  //     ),
  //     child: Text(
  //       label,
  //       style: semiBold(fontSize: 13.sp, color: AppColors.primary),
  //     ),
  //   );
  // }
}
