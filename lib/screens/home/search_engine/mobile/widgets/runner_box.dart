import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/guest_create_account_sheet.dart';
import 'package:puntgpt_nick/models/home/search_engine/runner_model.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';

class RunnerBox extends StatelessWidget {
  const RunnerBox({
    super.key,
    required this.runner,
    required this.onAddToTipSlip,
    required this.onCompareToField,
    required this.onAddToSaveSearch,
  });
  final RunnerModel runner;
  final VoidCallback onAddToTipSlip;
  final VoidCallback onCompareToField;
  final Function(String name, BuildContext context) onAddToSaveSearch;

  @override
  Widget build(BuildContext context) {
    final isGuest = !LocaleStorageService.isUserLoggedIn;
    final padding = EdgeInsets.fromLTRB(8.w, 0, 8.w, 3);
    return Container(
      margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* first row section
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 12, 8.w, 3),
            child: Row(
              children: [
                // AnimatedContainer(
                //   duration: const Duration(milliseconds: 250),
                //   curve: Curves.easeInOut,
                //   width: 22,
                //   height: 22,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color:
                //           // isChecked
                //           //     ? Colors.green
                //           //     :
                //           AppColors.primary.setOpacity(0.15),
                //     ),
                //     color: Colors
                //         .transparent, //isChecked ? Colors.green : Colors.transparent,
                //   ),
                //   child: Icon(Icons.check, color: Colors.white, size: 16),
                //
                // ),
                Text(
                  runner.barrier != null ? "${runner.barrier}. " : '-',
                  style: bold(fontSize: 18.sp),
                ),
                if ((runner.silksImage ?? '').isNotEmpty)
                  ImageWidget(
                    path: runner.silksImage!,
                    type: ImageType.svg,
                    height: 24.w,
                  ),
                if ((runner.silksImage ?? '').isNotEmpty) 4.horizontalSpace,
                Text(runner.horseName ?? '-', style: semiBold(fontSize: 18.sp)),
                Spacer(),
                Text(
                  runner.odds != null ? "\$${runner.odds} " : '-',
                  style: bold(fontSize: 18.sp),
                ),
                // if (context.read<SearchEngineProvider>().saveSearches?.any(
                //       (element) => element.id == runner.selectionId,
                //     ) ??
                //     false)
                //   Icon(Icons.bookmark_add_outlined)
                // else
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (isGuest) {
                      showGuestCreateAccountSheet(
                        context,
                        message: AppStrings.guestSaveSearchMessage,
                      );
                      return;
                    }
                    _showSaveSearchDialog(
                      context: context,
                      onSave: onAddToSaveSearch,
                    );
                  },
                  child: Icon(Icons.bookmark_add_outlined),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.primary.withValues(alpha: 0.15)),
          //*----------- second row section
          Padding(
            padding: padding,
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.start,
                  "${runner.jumpTimeAu?.split(" ").first ?? '-'}\n${DateFormatter.formatTimeFromString(runner.jumpTimeAu)}",
                  style: medium(fontSize: 16.sp),
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.start,
                    runner.jockeyName ?? '-',
                    style: medium(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.primary.withValues(alpha: 0.15)),
          //*----------- third row section
          Padding(
            padding: padding,
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Odds may differ with:", style: bold(fontSize: 16.sp)),
                ImageWidget(path: AppAssets.unibatLogo, height: 26.w),
              ],
            ),
          ),
          // Divider(color: AppColors.greyColor.withValues(alpha: 0.15)),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(12, 6, 12, 2),
          //   child: Text(
          //     "Next race ${runner.nextRaceRemainTime}",
          //     style: medium(fontSize: 16.sp),
          //   ),
          // ),
          Divider(color: AppColors.primary.withValues(alpha: 0.15)),
          Padding(
            padding: padding,
            child: Row(
              spacing: 6.w,
              children: [
                Expanded(
                  child: AppFilledButton(
                    text: "Add to Tip Slip",
                    textStyle: semiBold(
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 6.w,
                    ),

                    onTap: onAddToTipSlip,
                    // child: progressIndicator(),
                    child: _isThisRunnerLoading(context)
                        ? progressIndicator()
                        : null,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onCompareToField.call();

                      showCompareToField(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageWidget(path: AppAssets.horse, height: 24.w),
                          Expanded(
                            child: Text(
                              "Compare to field",
                              textAlign: TextAlign.center,
                              style: bold(fontSize: 14.sp),
                            ),
                          ),
                        ],
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

  Future<dynamic> showCompareToField(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (modalContext) {
        return Container(
          margin: EdgeInsets.fromLTRB(22.w, 5.h, 22.w, 25.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Consumer<SearchEngineProvider>(
            builder: (_, provider, __) {
              if (provider.compareHorse == null) {
                return HomeSectionShimmers.fieldComparisonShimmer(
                  context: modalContext,
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 12.h),
                    child: Text(
                      "Analysis and Field Comparison",
                      style: semiBold(fontSize: 16.sp),
                    ),
                  ),
                  Divider(color: AppColors.primary.withValues(alpha: 0.2)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(22.w, 10.h, 22.w, 16.h),
                    child: Text(
                      provider.compareHorse?.summary ??
                          "Unable to load analysis.",
                      style: regular(fontSize: 16.sp),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showSaveSearchDialog({
    required BuildContext context,
    required Function(String name, BuildContext context) onSave,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ZoomIn(
          child: _SaveSearchDialogContent(
            onCancel: () => context.pop(dialogContext),
            onSave: onSave,
          ),
        );
      },
    );
  }

  bool _isThisRunnerLoading(BuildContext context) {
    final provider = context.read<SearchEngineProvider>();
    return provider.isCreatingTipSlip &&
        provider.creatingForSelectionId == runner.selectionId?.toString();
  }
}

class _SaveSearchDialogContent extends StatefulWidget {
  const _SaveSearchDialogContent({
    required this.onCancel,
    required this.onSave,
  });
  final VoidCallback onCancel;
  final void Function(String name, BuildContext context) onSave;

  @override
  State<_SaveSearchDialogContent> createState() =>
      _SaveSearchDialogContentState();
}

class _SaveSearchDialogContentState extends State<_SaveSearchDialogContent> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text(
        "Save Search",
        style: semiBold(fontSize: 18.sp, color: AppColors.black),
      ),
      content: AppTextField(
        controller: _nameController,
        hintText: "Enter search name",
        textStyle: medium(fontSize: 16.sp, color: AppColors.black),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text("Cancel", style: medium(fontSize: 16.sp)),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) {
              AppToast.error(
                context: context,
                message: "Please enter a search name",
              );
              return;
            }
            widget.onSave(name, context);
          },
          child: Text("Yes", style: semiBold(fontSize: 16.sp)),
        ),
      ],
    );
  }
}
