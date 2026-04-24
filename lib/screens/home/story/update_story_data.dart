import 'dart:io';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';

class UploadStoryData extends StatefulWidget {
  const UploadStoryData({super.key});

  @override
  State<UploadStoryData> createState() => _UploadStoryDataState();
}

class _UploadStoryDataState extends State<UploadStoryData> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _affiliateUrlController = TextEditingController();
  String _lastSection = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final provider = context.read<StoryProvider>();

      if (!mounted) return;
      _syncFromSection(provider);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<StoryProvider>();
    final section = provider.selectedStorySection;
    if (_lastSection != section) {
      _syncFromSection(provider);
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _affiliateUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit({required StoryProvider provider}) async {
    if (provider.isUpdatingStoryData) return;
    final displayName = _displayNameController.text.trim();
    final hasAvatar =
        provider.storyDataAvatarFile != null ||
        _avatarUrlForSection(provider).isNotEmpty;
    if (displayName.isEmpty) {
      AppToast.error(context: context, message: 'Display name is required');
      return;
    }
    if (!hasAvatar) {
      AppToast.error(context: context, message: 'Avatar is required');
      return;
    }
    provider.setStoryDataDisplayName(displayName);
    // Intentionally allow empty affiliate URL so admin can clear it.
    provider.setStoryDataAffiliateUrl(_affiliateUrlController.text.trim());

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.backGroundColor,
          title: Text(
            'Save story data?',
            style: semiBold(fontSize: 17.fSize, color: AppColors.primary),
          ),
          content: Text(
            'This will update display name, affiliate URL, and avatar for this section.',
            style: regular(
              fontSize: 14.fSize,
              color: AppColors.primary.withValues(alpha: 0.65),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'Cancel',
                style: semiBold(fontSize: 14.fSize, color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                'Save',
                style: semiBold(fontSize: 14.fSize, color: AppColors.green),
              ),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;

    await provider.updateStoryData(
      onSuccess: () {
        AppToast.success(
          context: context,
          message: "Story data updated successfully. Please check the story",
        );
      },
    );
  }

  void _syncFromSection(StoryProvider provider) {
    final section = provider.selectedStorySection;
    _lastSection = section;
    final story = provider.stories
        ?.where((s) => s.section == section)
        .firstOrNull;
    final name = story?.title ?? '';
    final link = story?.affiliateUrl ?? '';
    provider.setStoryDataDisplayName(name);
    provider.setStoryDataAffiliateUrl(link);
    _displayNameController.text = name;
    _affiliateUrlController.text = link;
    _displayNameController.selection = TextSelection.collapsed(
      offset: _displayNameController.text.length,
    );
    _affiliateUrlController.selection = TextSelection.collapsed(
      offset: _affiliateUrlController.text.length,
    );
  }

  String _avatarUrlForSection(StoryProvider provider) {
    final section = provider.selectedStorySection;
    final story = provider.stories
        ?.where((s) => s.section == section)
        .firstOrNull;
    final logo = story?.logo.trim() ?? '';
    if (logo.isEmpty) return '';
    if (logo.startsWith('http://') || logo.startsWith('https://')) return logo;
    return '${AppConfig.baseurl}$logo';
  }

  @override
  Widget build(BuildContext context) {
    final selectedSection = context.select<StoryProvider, String>(
      (p) => p.selectedStorySection,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppScreenTopBar(
          title: 'Update Story Data',
          slogan: 'Update display name, URL and avatar',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
            child: Container(
              padding: EdgeInsets.all(16.w),

              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18.w),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.w,
                      ),
                      margin: EdgeInsets.only(bottom: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Text(
                        "Section: ${selectedSection.toUpperCase()}",
                        style: semiBold(
                          fontSize: 12.fSize,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  AppTextField(
                    controller: _displayNameController,
                    margin: EdgeInsets.only(bottom: 12.w),
                    onChanged: (v) => context
                        .read<StoryProvider>()
                        .setStoryDataDisplayName(v),
                    hintText: 'Display Name (optional) - PuntGPT Pro',
                  ),

                  AppTextField(
                    controller: _affiliateUrlController,
                    margin: EdgeInsets.only(bottom: 12.w),
                    onChanged: (v) => context
                        .read<StoryProvider>()
                        .setStoryDataAffiliateUrl(v),
                    keyboardType: TextInputType.url,
                    hintText: "Affiliate url (optional) - https://new-link.com",
                  ),
                  Consumer<StoryProvider>(
                    builder: (context, provider, _) {
                      final selected = provider.storyDataAvatarFile;
                      final networkUrl = _avatarUrlForSection(provider);
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.w),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppColors.greyColor.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.w),
                              child: selected != null
                                  ? Image.file(
                                      File(selected.path),
                                      width: 56.w,
                                      height: 56.w,
                                      fit: BoxFit.cover,
                                    )
                                  : (networkUrl.isNotEmpty
                                        ? Image.network(
                                            networkUrl,
                                            width: 56.w,
                                            height: 56.w,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _avatarPlaceholder(),
                                          )
                                        : _avatarPlaceholder()),
                            ),
                            10.w.horizontalSpace,
                            Expanded(
                              child: Text(
                                selected != null
                                    ? 'Selected: ${selected.name}'
                                    : (networkUrl.isNotEmpty
                                          ? 'Current avatar'
                                          : 'No avatar uploaded'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: regular(
                                  fontSize: 13.fSize,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.75,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Consumer<StoryProvider>(
                    builder: (context, provider, _) {
                      return Material(
                        color: AppColors.greyColor.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(12.w),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.w),
                          onTap: provider.isPickingStoryDataAvatar
                              ? null
                              : provider.pickStoryDataAvatar,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 14.w,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: AppColors.primary,
                                  size: 22.wSize,
                                ),
                                10.w.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    provider.storyDataAvatarFile == null
                                        ? 'Pick avatar (optional)'
                                        : provider.storyDataAvatarFile!.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: regular(
                                      fontSize: 13.fSize,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                                ),
                                if (provider.isPickingStoryDataAvatar)
                                  SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  )
                                else if (provider.storyDataAvatarFile != null)
                                  InkWell(
                                    onTap: provider.clearStoryDataAvatar,
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 18.wSize,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Consumer<StoryProvider>(
            builder: (context, provider, _) {
              final canSave = !provider.isUpdatingStoryData;
              return AppFilledButton(
                margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 12.w),
                text: "Save story data",
                onTap: canSave
                    ? () async {
                        await _submit(provider: provider);
                      }
                    : () {},
                child: provider.isUpdatingStoryData
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: AppColors.white,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          8.w.horizontalSpace,
                          Text(
                            'Saving...',
                            style: semiBold(
                              fontSize: 14.fSize,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 56.w,
      height: 56.w,
      color: AppColors.greyColor.withValues(alpha: 0.45),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        color: AppColors.primary.withValues(alpha: 0.4),
        size: 22.wSize,
      ),
    );
  }
}
