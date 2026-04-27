import 'dart:ui';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_screen_tab_web.dart';

class SelectedMeetingScreenWeb extends StatefulWidget {
  const SelectedMeetingScreenWeb({super.key});

  @override
  State<SelectedMeetingScreenWeb> createState() =>
      _SelectedMeetingScreenWebState();
}

class _SelectedMeetingScreenWebState extends State<SelectedMeetingScreenWeb> {
  String selItem = "R1";

  @override
  Widget build(BuildContext context) {
    final bodyWidth = context.isMobileWeb
        ? 1.6.sw
        : context.isTablet
        ? 1300.w
        : 1100.w;

    //     ? 16.sp
    //     : context.isTablet
    //     ? 24.sp
    //     : (context.isMobileWeb)
    //     ? 32.sp
    //     : 16.sp;
    // final eighteenResponsive = context.isDesktop
    //     ? 18.sp
    //     : context.isTablet
    //     ? 26.sp
    //     : (context.isMobileWeb)
    //     ? 34.sp
    //     : 16.sp;
    // final fourteenResponsive = context.isDesktop
    //     ? 14.sp
    //     : context.isTablet
    //     ? 22.sp
    //     : (context.isMobileWeb)
    //     ? 26.sp
    //     : 14.sp;
    return Align(
      alignment: Alignment.topCenter,
      child: Consumer<SearchEngineProvider>(
        builder: (context, provider, child) {
          return SizedBox(
            width: bodyWidth,
            child: SingleChildScrollView(
              // padding: EdgeInsets.symmetric(
              //   horizontal: (context.isMobileWeb) ? 55.w : 25.w,
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (kIsWeb && !context.isMobileView) ...[
                  SizedBox(height: 60),

                  Center(
                    child: HomeScreenTabWeb(
                      selectedIndex: provider.selectedTab,
                      onTap: () {
                        context.pop();
                      },
                    ),
                  ),
                  // ] else ...[
                  //   // SizedBox(height: 16),
                  //   HomeScreenTab(
                  //     selectedIndex: provider.selectedTab,
                  //     onTap: () {
                  //       context.pop();
                  //     },
                  //   ),
                  // ],

                  //* top bar
                  _topBar(
                    context: context,
                    // sixteenResponsive: sixteenResponsive,
                    // eighteenResponsive: eighteenResponsive,
                  ),
                  //* drop down
                  SizedBox(
                    width: 210,
                    child: Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: OnMouseTap(
                          child: AppTextFieldDropdown(
                            textStyle: medium(fontSize: 12),
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
                    // sixteenResponsive: sixteenResponsive,
                    // fourteenResponsive: fourteenResponsive,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //* top bar
  Widget _topBar({
    required BuildContext context,
    // required double sixteenResponsive,
    // required double eighteenResponsive,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            spacing: 16,
            children: [
              OnMouseTap(
                onTap: () {
                  context.pop();
                },
                child: Icon(Icons.arrow_back_ios_rounded, size: 16),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flemington",
                    style: regular(
                      fontSize: 18,
                      // context.isDesktop
                      //     ? 20.sp
                      //     : context.isTablet
                      //     ? 28.sp
                      //     : (context.isMobileWeb)
                      //     ? 36.sp
                      //     : 20.sp,
                      fontFamily: AppFontFamily.secondary,
                      height: 1.35,
                    ),
                  ),
                  Text(
                    "PuntGPT Legends Stakes 3200m. Date. Time",
                    style: semiBold(
                      fontSize: 11,
                      //  context.isDesktop
                      //     ? 12.sp
                      //     : context.isTablet
                      //     ? 20.sp
                      //     : (context.isMobileWeb)
                      //     ? 24.sp
                      //     : 12.sp,
                      color: AppColors.primary.withValues(alpha: 0.6),
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
    // required this.sixteenResponsive,
    // required this.fourteenResponsive,
  });

  final double bodyWidth;
  // final double sixteenResponsive, fourteenResponsive;

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
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          width: widget.bodyWidth,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Table(
            border: TableBorder.symmetric(
              inside: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            columnWidths: {0: FlexColumnWidth(0.8), 1: FlexColumnWidth(2)},
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
                            vertical: 12,
                            horizontal: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ${horses[index]["name"]!}",
                                style: semiBold(
                                  fontSize: 14,
                                  color: isExpanded ? Colors.white : null,
                                ),
                              ),
                              if (isExpanded) ...[
                                SizedBox(height: 10),
                                Text(
                                  "\$2.10",
                                  style: semiBold(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                AppFilledButton(
                                  margin: EdgeInsets.only(top: 4),
                                  text: "Add to Tip Slip",
                                  textStyle: semiBold(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 8),
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
                                          fontSize: 12,
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
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
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
