import 'dart:io';

import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';

/// Admin: create new story section (avatar uses same `StoryProvider` draft as update).
class CreateNewStorySection extends StatefulWidget {
  const CreateNewStorySection({super.key});

  @override
  State<CreateNewStorySection> createState() => _CreateNewStorySectionState();
}

class _CreateNewStorySectionState extends State<CreateNewStorySection> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _affiliateUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Avoid showing a file picked earlier on the update screen.
      context.read<StoryProvider>().clearStoryDataAvatar();
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _affiliateUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //* Top Bar
          AppScreenTopBar(
            title: 'Create New Story Section',
            slogan:
                'Add a fresh channel—name it, link it, and give it a face users will recognise.',
          ),
          //* Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.w),
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
                          'Section: NEW',
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
                      hintText: 'Display Name (optional) - PuntGPT Pro',
                      validator: (value) {
                        return FieldValidators().required(
                          value,
                          "Display Name",
                        );
                      },
                    ),
                    AppTextField(
                      controller: _affiliateUrlController,
                      margin: EdgeInsets.only(bottom: 12.w),
                      keyboardType: TextInputType.url,
                      hintText:
                          'Affiliate url (optional) - https://new-link.com',
                    ),
                    Consumer<StoryProvider>(
                      builder: (context, provider, _) {
                        final file = provider.storyDataAvatarFile;
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
                                child: file != null
                                    ? Image.file(
                                        File(file.path),
                                        width: 56.w,
                                        height: 56.w,
                                        fit: BoxFit.cover,
                                      )
                                    : _avatarPlaceholder(),
                              ),
                              10.w.horizontalSpace,
                              Expanded(
                                child: Text(
                                  file != null
                                      ? 'Selected: ${file.name}'
                                      : 'No avatar selected',
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
          //* Create Button
          AppFilledButton(
            margin: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 10.w),
            text: "Create section",
            onTap: () {
              if (!_formKey.currentState!.validate()) return;

              final provider = context.read<StoryProvider>();
              provider.setStoryDataDisplayName(
                _displayNameController.text.trim(),
              );
              provider.setStoryDataAffiliateUrl(
                _affiliateUrlController.text.trim(),
              );
              if (provider.storyDataAvatarFile == null) {
                AppToast.info(context: context, message: 'Avatar is required');
                return;
              }
              provider.createStorySection(
                onSuccess: () {
                  AppToast.success(
                    context: context,
                    message: "New section created successfully",
                  );
                },
              );
            },
          ),
        ],
      ),
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
