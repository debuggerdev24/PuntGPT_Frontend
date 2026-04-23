import 'package:puntgpt_nick/core/app_imports.dart';

/// Admin: choose whether to update media content or story metadata.
class EditStoryOptionScreen extends StatelessWidget {
  const EditStoryOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppScreenTopBar(
          title: 'Edit story',
          slogan: 'Choose what you want to update',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _EditOptionTile(
                  icon: Icons.perm_media_outlined,
                  title: 'Upload story content',
                  subtitle: 'Upload or replace the image and video shown in the story.',
                  onTap: () =>
                      context.pushNamed(AppRoutes.uploadStoryContent.name),
                ),
                16.w.verticalSpace,
                _EditOptionTile(
                  icon: Icons.edit_note_rounded,
                  title: 'Update story data',
                  subtitle: 'Change thumbnail, links, name, and other story details.',
                  onTap: () =>
                      context.pushNamed(AppRoutes.uploadStoryData.name),
                ),
                16.w.verticalSpace,
                _EditOptionTile(
                  destructive: true,
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete story content',
                  subtitle:
                      'Remove uploaded images or videos for this story section.',
                  onTap: () =>
                      context.pushNamed(AppRoutes.deleteStoryContent.name),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditOptionTile extends StatelessWidget {
  const _EditOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final accent = destructive ? AppColors.red : AppColors.primary;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: destructive
                      ? AppColors.red.withValues(alpha: 0.1)
                      : AppColors.greyColor.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Icon(icon, size: 26.wSize, color: accent),
              ),
              14.w.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: semiBold(fontSize: 16.fSize, color: accent),
                    ),
                    4.w.verticalSpace,
                    Text(
                      subtitle,
                      style: regular(
                        fontSize: 13.fSize,
                        color: AppColors.primary.withValues(alpha: 0.55),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary.withValues(alpha: 0.35),
                size: 24.wSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
