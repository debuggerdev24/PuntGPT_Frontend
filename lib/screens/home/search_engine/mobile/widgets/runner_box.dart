import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/core/widgets/guest_create_account_sheet.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/models/home/search_engine/runner_model.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/mobile/widgets/home_section_shimmers.dart';


String _displayName(String? name) {
  final t = name?.trim();
  if (t == null || t.isEmpty) return '—';
  return t;
}

class RunnerBox extends StatelessWidget {
  const RunnerBox({
    super.key,
    required this.index,
    required this.runner,
    required this.onAddToTipSlip,
    required this.onCompareToField,
    required this.onAddToSaveSearch,
    required this.onOpenClassicFormGuide,
  });
  final RunnerModel runner;
  final int index;
  final VoidCallback onAddToTipSlip, onCompareToField, onOpenClassicFormGuide;
  final Function(String name, BuildContext context) onAddToSaveSearch;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.fromLTRB(8.w, 0, 8.w, 3);
    final jumpTime = runner.jumpTimeAu!.split(" ");
    return GestureDetector(
      onTap: onOpenClassicFormGuide,
      child: Container(
        margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //*----------- first row horse detailss
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 12, 8.w, 3.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$index. ", style: bold(fontSize: 18.sp)),
                  if ((runner.silksImage ?? '').isNotEmpty)
                    ImageWidget(
                      path: runner.silksImage!,
                      type: ImageType.svg,
                      height: 28.w,
                    ),
                  if ((runner.silksImage ?? '').isNotEmpty) 4.horizontalSpace,
                  Expanded(
                    child: Text(
                      "${runner.horseName ?? '-'} (${runner.barrier ?? '-'})",
                      style: semiBold(fontSize: 18.sp),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => launchUnibetUrl(),
                    child: ImageWidget(
                      path: AppAssets.unibatLogo,
                      height: 26.w,
                    ),
                  ),
                  6.w.horizontalSpace,
                  Text(
                    runner.odds != null ? "\$${runner.odds} " : '- ',
                    style: bold(fontSize: 18.sp),
                  ),
                  if (!isGuest)
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
            //*----------- second row: race details + jockey / trainer
            Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    [
                      runner.track ?? '-',
                      "R${runner.raceNumber ?? '-'}",
                      "${runner.distance ?? '-'}m",
                     (jumpTime != null) ? "${jumpTime[1].split(":")[0]}:${jumpTime[1].split(":")[1]} ${jumpTime[2]}" : "-",
                    ].join(" - "),
                    style: semiBold(fontSize: 15.sp, height: 1.25
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 6,
                          children: [
                            _RunnerStatCell(
                              label: 'W',
                              value: "${runner.weight}" ,
                            ),
                            _RunnerStatCell(
                              label: 'F',
                              value: runner.form ?? "-",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _RunnerStatCell(
                              label: 'J',
                              value: _displayName(runner.jockeyName),
                            ),

                            _RunnerStatCell(
                              label: 'T',
                              value: _displayName(runner.trainerName),
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.primary.withValues(alpha: 0.15)),
            //*----------- third row section
            Padding(
              padding: padding,
              child: Row(
                children: [
                  Text(
                    "Odds may differ with :  ",
                    style: bold(fontSize: 16.sp),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => launchDabbleUrl(),
                    child: ImageWidget(
                      path: AppAssets.dabbleLogo,
                      height: 26.w,
                    ),
                  ),
                ],
              ),
            ),

            if (!isGuest) ...[
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
          ],
        ),
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
          margin: EdgeInsets.fromLTRB(22.w, 5.w, 22.w, 25.w),
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(14.w, 18.w, 14.w, 12.w),
                      child: Text(
                        "AI Analysis and Field Comparison",
                        style: semiBold(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(color: AppColors.primary.withValues(alpha: 0.2)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 10.w, 22.w, 12.w),
                      child: Text(
                        provider.compareHorse?.summary ??
                            "Unable to load analysis.",
                        style: regular(fontSize: 16.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 20.w),
                      child: Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.menu_book_outlined,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                                10.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    "Tip: analysis often ends with “refer to the Classic Form Guide”. "
                                    "Use Classic Form on the home tab to view the full field for this race.",
                                    style: medium(fontSize: 14.sp, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                            14.verticalSpace,
                            OnMouseTap(
                              onTap: () {
                                modalContext.pop();
                                onOpenClassicFormGuide.call();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Text(
                                  "Open Classic Form Guide",
                                  style: semiBold(fontSize: 15.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

/// Single-letter label + value; `Expanded` keeps long jockey/track names from overflowing.
class _RunnerStatCell extends StatelessWidget {
  const _RunnerStatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: semiBold(
            fontSize: 14.sp,
            color: AppColors.primary.withValues(alpha: 0.85),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: medium(fontSize: 15.sp, height: 1.25),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
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
/*
1.Go Pro for AI chat, search & Classic Form guide.
2.Next races, search & form — Ask PuntGPT anytime.
3.Filter fast, save searches, ask PuntGPT.
4.Chat with AI about racing anytime. 
5.Create a club and start chatting about the races.
6.Profile, subscription, and settings in one place.
7.Edit your profile and contact info anytime.
8.Check Pro plans and see your current one.
*/