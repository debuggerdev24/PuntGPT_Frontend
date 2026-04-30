import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/main.dart';
import 'package:puntgpt_nick/models/home/search_engine/runner_model.dart';
import 'package:puntgpt_nick/provider/home/classic_form/classic_form_provider.dart';
import 'package:puntgpt_nick/provider/home/search_engine/search_engine_provider.dart';
import 'package:puntgpt_nick/screens/home/search_engine/web/widgets/home_section_shimmers_web.dart';

class RunnersListWeb extends StatelessWidget {
  const RunnersListWeb({super.key, required this.runnersList});
  final List<RunnerModel> runnersList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            25.w,
            0.h,
            25.w,
            (context.isMobileWeb) ? 8.h : 12.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Runners: (20)",
                style: bold(fontSize: (context.isMobileWeb) ? 25.sp : 16.sp),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    (context.isMobileView && !kIsWeb)
                        ? WebRoutes.savedSearchedScreen.name
                        : AppRoutes.savedSearchedScreen.name,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageWidget(
                      type: ImageType.svg,
                      path: AppAssets.bookmark,
                      height: (context.isMobileWeb) ? 25.sp : 16.sp,
                    ),
                    5.horizontalSpace,
                    Text(
                      "Saved Searches",
                      style: bold(
                        fontSize: (context.isMobileWeb) ? 25.sp : 16.sp,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            itemCount: runnersList.length,
            separatorBuilder: (context, index) => 16.h.verticalSpace,
            itemBuilder: (context, index) {
              return RunnerBoxWeb(
                displayIndex: index + 1,
                runner: runnersList[index],
                onAddToTipSlip: () {},
                onCompareToField: () {},
                onSaveSearch: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Web runner card — same sections as mobile [RunnerBox], with web font sizes.
class RunnerBoxWeb extends StatelessWidget {
  const RunnerBoxWeb({
    super.key,
    required this.runner,
    required this.displayIndex,
    required this.onAddToTipSlip,
    required this.onCompareToField,
    required this.onSaveSearch,
  });

  final RunnerModel runner;
  final int displayIndex;
  final VoidCallback onAddToTipSlip, onCompareToField, onSaveSearch;

  @override
  Widget build(BuildContext context) {
    final titleFs = 13.0;
    final metaFs = 11.0;
    final silkSize = 22.0;
    final padH = 10.0;

    // Same race line idea as mobile: track - R# - distance - time
    String raceLine;
    final jumpTime = runner.jumpTimeAu!.split(' ');
    if (jumpTime.length >= 3) {
      final t = jumpTime[1].split(':');
      if (t.length >= 2) {
        raceLine =
            '${runner.track ?? '-'} - R${runner.raceNumber ?? '-'} - ${runner.distance ?? '-'}m - ${t[0]}:${t[1]} ${jumpTime[2]}';
      } else {
        raceLine =
            '${runner.track ?? '-'} - R${runner.raceNumber ?? '-'} - ${runner.distance ?? '-'}m';
      }
    } else {
      raceLine =
          '${runner.track ?? '-'} - R${runner.raceNumber ?? '-'} - ${runner.distance ?? '-'}m';
    }

    return GestureDetector(
      onTap: () async {
        final classicForm = context.read<ClassicFormProvider>();
        classicForm.setTempLoading = true;
        await Future.wait([
          classicForm.getMeetingRaceList(
            meetingId: runner.meetingId.toString(),
          ),
          classicForm.getRaceFieldDetail(id: runner.raceId?.toString() ?? ''),
        ]);
        classicForm.setTempLoading = false;
        if (!context.mounted) return;
        context.pushNamed(
          kIsWeb ? WebRoutes.selectedRace.name : AppRoutes.selectedRace.name,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: (context.isMobileWeb) ? 0 : 13),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Row 1: number, silk, horse, unibet, odds, bookmark
              Padding(
                padding: EdgeInsets.fromLTRB(padH, 10, padH, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$displayIndex. ', style: bold(fontSize: titleFs)),
                    if ((runner.silksImage ?? '').isNotEmpty) ...[
                      ImageWidget(
                        path: runner.silksImage!,
                        type: ImageType.svg,
                        height: silkSize,
                        width: silkSize,
                        placeholder: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Shimmer.fromColors(
                            baseColor: AppColors.shimmerBaseColor,
                            highlightColor: AppColors.shimmerHighlightColor,
                            child: Container(
                              width: silkSize - 4,
                              height: silkSize - 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        '${runner.horseName ?? '-'} (${runner.barrier ?? '-'})',
                        style: semiBold(fontSize: titleFs, height: 1.2),
                      ),
                    ),
                    OnMouseTap(
                      onTap: () => launchUnibetUrl(),
                      child: ImageWidget(
                        path: AppAssets.unibatLogo,
                        height: context.isDesktop ? 22.0 : 24.w,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      runner.odds != null ? '\$${runner.odds} ' : '- ',
                      style: bold(fontSize: titleFs),
                    ),
                    if (!isGuest)
                      OnMouseTap(
                        onTap: () {
                          final nameController = TextEditingController();
                          showDialog<void>(
                            context: context,
                            builder: (dialogContext) {
                              return ZoomIn(
                                child: AlertDialog(
                                  backgroundColor: AppColors.white,
                                  title: Text(
                                    'Save Search',
                                    style: semiBold(
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  content: AppTextField(
                                    controller: nameController,
                                    hintText: 'Enter search name',
                                    textStyle: medium(
                                      fontSize: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.pop(dialogContext);
                                        nameController.dispose();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: medium(fontSize: 16),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final name = nameController.text.trim();
                                        if (name.isEmpty) {
                                          AppToast.error(
                                            context: context,
                                            message:
                                                'Please enter a search name',
                                          );
                                          return;
                                        }
                                        context.pop(dialogContext);
                                        nameController.dispose();
                                        context
                                            .read<SearchEngineProvider>()
                                            .createSaveSearch(
                                              name: name,
                                              onError: (error) {
                                                AppToast.error(
                                                  context: context,
                                                  message: error,
                                                );
                                              },
                                              onSuccess: () {
                                                AppToast.success(
                                                  context: context,
                                                  message:
                                                      'Search saved successfully',
                                                );
                                              },
                                            );
                                      },
                                      child: Text(
                                        'Yes',
                                        style: semiBold(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.bookmark_add_outlined,
                            size: context.isDesktop ? 20 : 22.w,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              horizontalDivider(opacity: 0.15),

              //* Row 2: race line + W/F + J/T
              Padding(
                padding: EdgeInsets.fromLTRB(padH, 8, padH, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      raceLine,
                      style: semiBold(fontSize: metaFs + 1, height: 1.25),
                    ),
                    SizedBox(height: context.isDesktop ? 8 : 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'W: ',
                                    style: semiBold(
                                      fontSize: metaFs,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      runner.weight ?? '-',
                                      style: medium(
                                        fontSize: metaFs + 0.5,
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'F: ',
                                    style: semiBold(
                                      fontSize: metaFs,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      runner.form ?? '-',
                                      style: medium(
                                        fontSize: metaFs + 0.5,
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: context.isDesktop ? 12 : 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'J: ',
                                    style: semiBold(
                                      fontSize: metaFs,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      (runner.jockeyName ?? '').trim().isEmpty
                                          ? '—'
                                          : runner.jockeyName!,
                                      style: medium(
                                        fontSize: metaFs + 0.5,
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'T: ',
                                    style: semiBold(
                                      fontSize: metaFs,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      (runner.trainerName ?? '').trim().isEmpty
                                          ? '—'
                                          : runner.trainerName!,
                                      style: medium(
                                        fontSize: metaFs + 0.5,
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              horizontalDivider(opacity: 0.15),

              //* Row 3: odds disclaimer
              Padding(
                padding: EdgeInsets.fromLTRB(padH, 8, padH, 8),
                child: Row(
                  children: [
                    Text(
                      'Odds may differ with :  ',
                      style: bold(fontSize: metaFs + 1),
                    ),
                    OnMouseTap(
                      onTap: () => launchDabbleUrl(),
                      child: ImageWidget(
                        path: AppAssets.dabbleLogo,
                        height: 22,
                      ),
                    ),
                  ],
                ),
              ),

              if (!isGuest) ...[
                horizontalDivider(opacity: 0.15),
                Padding(
                  padding: EdgeInsets.fromLTRB(padH, 10, padH, 10),
                  child: Row(
                    children: [
                      //* Add to Tip Slip button
                      Expanded(
                        child: Consumer<SearchEngineProvider>(
                          builder: (context, provider, _) {
                            final loading =
                                provider.isCreatingTipSlip &&
                                provider.creatingForSelectionId ==
                                    runner.selectionId?.toString();
                            return AppFilledButton(
                              text: 'Add to Tip Slip',
                              textStyle: semiBold(
                                fontSize: 
                                     12.0
                                    ,
                                color: AppColors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                              onTap: () {
                                provider.createTipSlip(
                                  selectionId:
                                      runner.selectionId?.toString() ?? '',
                                  context: context,
                                );
                              },
                              child: loading ? progressIndicator() : null,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: OnMouseTap(
                          onTap: () async {
                            final provider = context
                                .read<SearchEngineProvider>();
                            await provider.compareHorses(
                              selectionId: runner.selectionId?.toString() ?? '',
                            );
                            if (!context.mounted) return;

                            await showModalBottomSheet<void>(
                              showDragHandle: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (modalContext) {
                                return Container(
                                  margin: EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.15,
                                      ),
                                    ),
                                  ),
                                  child: Consumer<SearchEngineProvider>(
                                    builder: (_, p, __) {
                                      if (p.compareHorse == null) {
                                        return WebSectionShimmers.fieldComparisonShimmer(
                                          context: modalContext,
                                        );
                                      }
                                      return SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                14.w,
                                                18.h,
                                                14.w,
                                                12.h,
                                              ),
                                              child: Text(
                                                'AI Analysis and Field Comparison',
                                                style: semiBold(fontSize: 13),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Divider(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.2),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                22.w,
                                                10.h,
                                                22.w,
                                                12.h,
                                              ),
                                              child: Text(
                                                p.compareHorse?.summary ??
                                                    'Unable to load analysis.',
                                                style: regular(fontSize: 14),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                22.w,
                                                0,
                                                22.w,
                                                20.h,
                                              ),
                                              child: OnMouseTap(
                                                onTap: () async {
                                                  modalContext.pop();
                                                  final classicForm = context
                                                      .read<
                                                        ClassicFormProvider
                                                      >();
                                                  classicForm.setTempLoading =
                                                      true;
                                                  await Future.wait([
                                                    classicForm
                                                        .getMeetingRaceList(
                                                          meetingId: runner
                                                              .meetingId
                                                              .toString(),
                                                        ),
                                                    classicForm
                                                        .getRaceFieldDetail(
                                                          id:
                                                              runner.raceId
                                                                  ?.toString() ??
                                                              '',
                                                        ),
                                                  ]);
                                                  classicForm.setTempLoading =
                                                      false;
                                                  if (!context.mounted) return;
                                                  context.pushNamed(
                                                    kIsWeb
                                                        ? WebRoutes
                                                              .selectedRace
                                                              .name
                                                        : AppRoutes
                                                              .selectedRace
                                                              .name,
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 12.h,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Open Classic Form Guide',
                                                    style: semiBold(
                                                      fontSize: 14,
                                                    ),
                                                  ),
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
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 4,
                              ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ImageWidget(path: AppAssets.horse, height: 24.w),
                                Expanded(
                                  child: Text(
                                    'Compare field',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: bold(
                                      fontSize: 12),
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
      ),
    );
  }
}
