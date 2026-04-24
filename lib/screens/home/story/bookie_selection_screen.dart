import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';

class BookieSelectionScreen extends StatelessWidget {
  const BookieSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppScreenTopBar(
          title: 'Edit story',
          slogan: 'Select section before continuing',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Choose bookie",
                  style: semiBold(fontSize: 14.fSize, color: AppColors.primary),
                ),
                // 8.w.verticalSpace,
                Text(
                  "Only one bookie can be active at a time.",
                  style: regular(
                    fontSize: 12.fSize,
                    color: AppColors.primary.withValues(alpha: 0.58),
                  ),
                ),
                16.w.verticalSpace,
                Consumer<StoryProvider>(
                  builder: (context, storyProvider, _) {
                    final raw = storyProvider.stories;
                    if (raw == null || raw.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.w),
                        child: Center(
                          child: SizedBox(
                            width: 32.w,
                            height: 32.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                      );
                    }
                    final selected = storyProvider.selectedStorySection;
                    return ListView.separated(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: raw.length,
                      itemBuilder: (context, index) {
                        final story = raw[index];
                        return Slidable(
                          key: ValueKey<String>(story.section),
                          endActionPane: ActionPane(
                            motion: BehindMotion(),
                            extentRatio: 0.28,
                            children: [
                              SlidableAction(
                                onPressed: (_) =>
                                    _SectionSwitchTile.showDeleteSectionConfirmationDialog(
                                      context: context,
                                      sectionTitle: story.title,
                                      onConfirmDelete: () {
                                        storyProvider.deleteBookie(
                                          section: story.section,
                                          onSuccess: () {
                                            AppToast.success(
                                              context: context,
                                              message: "Bookie deleted successfully. Please check the story",
                                            );
                                          },
                                        );
                                        // *: wire StoryProvider delete section API.
                                      },
                                    ),
                                backgroundColor: AppColors.redButton,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_outline_rounded,
                                label: 'Delete',
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ],
                          ),
                          child: _SectionSwitchTile(
                            title: story.title,
                            value: selected == story.section,
                            onChanged: (_) =>
                                storyProvider.selectStorySection(story.section),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 10.w.verticalSpace,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        AppOutlinedButton(
          margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 0.w),
          text: "Continue",
          onTap: () => context.pushNamed(AppRoutes.editStoryOption.name),
        ),
        AppFilledButton(
          margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 10.w),
          text: "Create new Bookie",
          onTap: () {
            context.pushNamed(AppRoutes.createNewStorySection.name);
          },
        ),
      ],
    );
  }
}

class _SectionSwitchTile extends StatelessWidget {
  const _SectionSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  /// Same layout as tip slip / notification swipe-delete confirmation.
  static void showDeleteSectionConfirmationDialog({
    required BuildContext context,
    required String sectionTitle,
    required VoidCallback onConfirmDelete,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        content: Text(
          'Are you sure you want to delete "$sectionTitle"?',
          style: medium(fontSize: 18.sp, color: AppColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel', style: medium(fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirmDelete();
            },
            child: Text(
              'Yes',
              style: semiBold(fontSize: 16.sp, color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(14.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: value
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: semiBold(fontSize: 14.fSize, color: AppColors.primary),
              ),
            ),
            IgnorePointer(
              child: Radio<bool>(
                value: true,
                groupValue: value,
                onChanged: (_) {},
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
