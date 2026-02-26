import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';

bool isSearchDialogOpen = false;

class SearchSectionWeb extends StatefulWidget {
  const SearchSectionWeb({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  State<SearchSectionWeb> createState() => _SearchSectionWebState();
}

class _SearchSectionWebState extends State<SearchSectionWeb> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void onSaveSearchTap() {
    isSearchDialogOpen = true;
    showDialog(
      context: context,
      builder: (context) {
        return searchDialog(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchEngineProvider>(
      builder: (context, provider, child) => SizedBox(
        width: Responsive.isMobileWeb(context)
            ? double.maxFinite
            : context.isTablet
            ? 1200.w
            : 1100.w,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Search for a horse that meets your criteria:",
                  style: bold(
                    fontSize: context.isDesktop
                        ? 16.sp
                        : context.isTablet
                        ? 24.sp
                        : (context.isBrowserMobile)
                        ? 40.sp
                        : 16.sp,
                    height: 1.2,
                  ),
                ),
                OnMouseTap(
                  onTap: onSaveSearchTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageWidget(
                        type: ImageType.svg,
                        path: AppAssets.bookmark,
                        height: context.isDesktop
                            ? 16.sp
                            : context.isTablet
                            ? 24.sp
                            : (kIsWeb)
                            ? 30.sp
                            : 16.sp,
                      ),
                      5.w.horizontalSpace,
                      Text(
                        "Saved Searches",
                        style: bold(
                          fontSize: context.isDesktop
                              ? 16.sp
                              : context.isTablet
                              ? 24.sp
                              : (kIsWeb)
                              ? 30.sp
                              : 16.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            20.h.verticalSpace,
            //todo filter view
            _buildSearchView(),
          ],
        ),
      ),
    );
  }

  /// For Mobile

  Widget _buildSearchView() {
    final provider = context.watch<SearchEngineProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        horizontalDivider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //todo left panel
            SizedBox(
              width: 340.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: AppColors.transparent),
                    child: ExpansionTile(
                      childrenPadding: EdgeInsets.only(
                        left: 25.w,
                        right: 25.w,
                        bottom: 8.h,
                      ),
                      tilePadding: EdgeInsets.symmetric(horizontal: 25.w),
                      iconColor: AppColors.greyColor,
                      title: Text(
                        "Track",
                        style: semiBold(
                          fontSize: context.isDesktop
                              ? 14.sp
                              : context.isTablet
                              ? 22.sp
                              : (kIsWeb)
                              ? 26.sp
                              : 14.sp,
                        ),
                      ),
                      children: [
                        // Placed last start
                        InkWell(
                          onTap: () {
                            provider.togglePlacedLastStart(!provider.placedLastStart);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Column(
                            children: [
                              Divider(
                                color: AppColors.greyColor.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Placed last start",
                                      style: semiBold(
                                        fontSize: context.isDesktop
                                            ? 14.sp
                                            : context.isTablet
                                            ? 22.sp
                                            : (kIsWeb)
                                            ? 26.sp
                                            : 14.sp,
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      width: 22.sp,
                                      height: 22.sp,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: provider.placedLastStart
                                              ? Colors.green
                                              : AppColors.primary.setOpacity(
                                                  0.15,
                                                ),
                                        ),
                                        borderRadius: BorderRadius.circular(1),
                                        color: provider.placedLastStart
                                            ? Colors.green
                                            : Colors.transparent,
                                      ),
                                      child: provider.placedLastStart
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16.sp,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Won last start
                        InkWell(
                          onTap: () {
                            provider.toggleWonLastStart(!provider.wonLastStart);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Column(
                            children: [
                              Divider(
                                color: AppColors.greyColor.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Won last start",
                                      style: semiBold(
                                        fontSize: context.isDesktop
                                            ? 14.sp
                                            : context.isTablet
                                            ? 22.sp
                                            : (kIsWeb)
                                            ? 26.sp
                                            : 14.sp,
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      width: 22.sp,
                                      height: 22.sp,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: provider.wonLastStart
                                              ? Colors.green
                                              : AppColors.primary.setOpacity(
                                                  0.15,
                                                ),
                                        ),
                                        borderRadius: BorderRadius.circular(1),
                                        color: provider.wonLastStart
                                            ? Colors.green
                                            : Colors.transparent,
                                      ),
                                      child: provider.wonLastStart
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16.sp,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Won last 12 months
                        InkWell(
                          onTap: () {
                            provider.toggleWonLast12Months(!provider.wonLast12Months);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Column(
                            children: [
                              Divider(
                                color: AppColors.greyColor.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Won last 12 months",
                                      style: semiBold(
                                        fontSize: context.isDesktop
                                            ? 14.sp
                                            : context.isTablet
                                            ? 22.sp
                                            : (kIsWeb)
                                            ? 26.sp
                                            : 14.sp,
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      width: 22.sp,
                                      height: 22.sp,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: provider.wonLast12Months
                                              ? Colors.green
                                              : AppColors.primary.setOpacity(
                                                  0.15,
                                                ),
                                        ),
                                        borderRadius: BorderRadius.circular(1),
                                        color: provider.wonLast12Months
                                            ? Colors.green
                                            : Colors.transparent,
                                      ),
                                      child: provider.wonLast12Months
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16.sp,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalDivider(endIndent: 22),
                  90.h.verticalSpace,
                  if (provider.isSearched)
                    Text(
                      "Total Runners: (20)",
                      style: semiBold(
                        fontSize: context.isDesktop
                            ? 14.sp
                            : context.isTablet
                            ? 22.sp
                            : (kIsWeb)
                            ? 26.sp
                            : 14.sp,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  AppFilledButton(
                    margin: EdgeInsets.only(
                      right: 12.w,
                      top: provider.isSearched ? 12.h : 0,
                    ),
                    text: "Search",
                    padding: (!context.isBrowserMobile)
                        ? EdgeInsets.symmetric(
                            vertical: (context.isDesktop) ? 12.w : 11.w,
                          )
                        : null,

                    textStyle: semiBold(
                      color: AppColors.white,
                      fontSize: context.isDesktop
                          ? 14.sp
                          : context.isTablet
                          ? 22.sp
                          : (kIsWeb)
                          ? 26.sp
                          : 14.sp,
                    ),
                    onTap: () {
                      // formKey.currentState!.validate();
                      provider.setIsSearched(value: !provider.isSearched);
                    },
                  ),

                  AppOutlinedButton(
                    margin: EdgeInsets.only(
                      top: 8.h,
                      bottom: 70.h,
                      right: 12.w,
                    ),
                    text: "Save this Search",
                    padding: (!context.isBrowserMobile)
                        ? EdgeInsets.symmetric(vertical: 12.w)
                        : null, // (context.isDesktop) ? 12.w : 11.w,
                    textStyle: semiBold(
                      fontSize: context.isDesktop
                          ? 14.sp
                          : context.isTablet
                          ? 22.sp
                          : (kIsWeb)
                          ? 26.sp
                          : 14.sp,
                    ),

                    onTap: () {
                      // formKey.currentState!.validate();
                      provider.setIsSearched(value: true);
                    },
                  ),
                ],
              ),
            ),
            //todo right panel (Grid view)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.h.verticalSpace,
                  Text(
                    "Total Runners: (20)",
                    style: semiBold(
                      fontSize: context.isDesktop
                          ? 14.sp
                          : context.isTablet
                          ? 22.sp
                          : (kIsWeb)
                          ? 26.sp
                          : 14.sp,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
                  20.h.verticalSpace,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: context.isDesktop ? 1.55.w : 2.w,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemBuilder: (context, index) {
                      return SizedBox.shrink();//Runner(runner: provider.runnersList[0]);
                    },
                    itemCount: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Builds a single filter field (either text or dropdown)
  // Widget _buildFilterField(Map filter) {
  //   final label = filter["label"];
  //   final type = filter["type"];
  //
  //   if (type == "number") {
  //     return AppTextField(
  //       controller: _controllers[label]!,
  //       hintText: "Enter $label",
  //       validator: (value) {
  //         if (value == null || value.trim().isEmpty) {
  //           return "$label is required";
  //         }
  //         final number = num.tryParse(value);
  //         if (number == null) {
  //           return "Please enter a valid number";
  //         }
  //         return null;
  //       },
  //     );
  //   } else {
  //     return AppTextFieldDropdown(
  //       items: List<String>.from(filter["options"]),
  //       selectedValue: _dropdownValues[label],
  //       hintText: "Select $label",
  //       onChange: (value) {
  //         setState(() => _dropdownValues[label] = value);
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return "Please select $label";
  //         }
  //         return null;
  //       },
  //     );
  //   }
  // }

  Widget searchDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //todo top bar of popup
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Saved Searches",
                  style: regular(
                    fontSize: context.isDesktop ? 22.sp : 30.sp,
                    fontFamily: AppFontFamily.secondary,
                  ),
                ),
                OnMouseTap(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.primary,
                    size: context.isDesktop ? 22.w : 30.w,
                  ),
                ),
              ],
            ),
          ),
          horizontalDivider(),
          //todo search items
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 28.w, 10.w, 0),
            child: Column(
              spacing: 28.w,
              children: [
                searchItem(),
                horizontalDivider(),
                searchItem(),
                horizontalDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppOutlinedButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.w,
                        horizontal: 18.w,
                      ),
                      margin: EdgeInsets.only(bottom: 6.h, top: 4.h),
                      isExpand: false,
                      textStyle: semiBold(
                        fontSize: context.isDesktop ? 14.sp : 22.sp,
                      ),
                      text: "Remove Searches",
                      onTap: () {},
                    ),
                    AppFilledButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.w,
                        horizontal: 18.w,
                      ),

                      margin: EdgeInsets.only(left: 8.w, bottom: 4.h, top: 4.h),
                      textStyle: semiBold(
                        fontSize: context.isDesktop ? 14.sp : 22.sp,
                        color: AppColors.white,
                      ),
                      isExpand: false,
                      text: "Edit",
                      onTap: () {},
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

  Widget searchItem() {
    return GestureDetector(
      onTap: () {
        context.pop();
        if (mounted) {
          context.pushNamed(AppRoutes.searchDetails.name);
        }
      },
      child: Row(
        spacing: 500.w,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search 1",
                style: semiBold(fontSize: context.isDesktop ? 16.sp : 24.sp),
              ),
              Text(
                "Sep 30, 2025",
                style: semiBold(
                  fontSize: context.isDesktop ? 12.sp : 20.sp,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
              6.5.h.verticalSpace,
              Text(
                "Randwick • 1200m • >20%",
                style: medium(fontSize: context.isDesktop ? 14.sp : 22.sp),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.black,
            size: 14.w,
          ),
        ],
      ),
    );
  }
}
