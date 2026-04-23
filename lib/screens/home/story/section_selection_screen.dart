import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';

class SectionSelectionScreen extends StatelessWidget {
  const SectionSelectionScreen({super.key});

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
                  "Choose section",
                  style: semiBold(fontSize: 14.fSize, color: AppColors.primary),
                ),
                // 8.w.verticalSpace,
                Text(
                  "Only one section can be active at a time.",
                  style: regular(
                    fontSize: 12.fSize,
                    color: AppColors.primary.withValues(alpha: 0.58),
                  ),
                ),
                16.w.verticalSpace,
                Consumer<StoryProvider>(
                  builder: (context, storyProvider, _) {
                    final selected = storyProvider.selectedStorySection;
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: storyProvider.stories!.length,
                      itemBuilder: (context, index) => _SectionSwitchTile(
                        title: storyProvider.stories![index].title,
                        value:
                            selected == storyProvider.stories![index].section,
                        onChanged: (_) =>
                            context.read<StoryProvider>().selectStorySection(
                              storyProvider.stories![index].section,
                            ),
                      ),
                      separatorBuilder: (context, index) => 10.w.verticalSpace,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        AppOutlinedButton(
          margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 10.w),
          text: "Continue",
          onTap: () => context.pushNamed(AppRoutes.editStoryOption.name),
        ),
        AppFilledButton(
          margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 10.w),
          text: "Create new section",
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(14.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.w),
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
