import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';

/// Admin: edit story - story content upload (one image and/or one video max).
class UploadStoryContent extends StatelessWidget {
  const UploadStoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppScreenTopBar(
          title: 'Edit Story',
          slogan: 'Upload story content for users',
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: context.read<StoryProvider>(),
            builder: (context, _) {
              final story = context.read<StoryProvider>();
              final hasImage = story.hasStoryContentImage;
              final hasVideo = story.hasStoryContentVideo;
              final videoSizeLabel = story.storyContentVideoSizeLabel();

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.w,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.green.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(8.w),
                                ),
                                child: Text(
                                  'Story content',
                                  style: semiBold(
                                    fontSize: 12.fSize,
                                    color: AppColors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.w.verticalSpace,
                          Text(
                            'Add one file (image or video)',
                            style: regular(
                              fontSize: 15.fSize,
                              color: AppColors.primary.withValues(
                                alpha: 0.75,
                              ),
                              height: 1.35,
                            ),
                          ),
                          6.w.verticalSpace,
                          Text(
                            'Pick a single file. If you pick again, it replaces the previous file.',
                            style: regular(
                              fontSize: 12.fSize,
                              color: AppColors.primary.withValues(
                                alpha: 0.45,
                              ),
                              height: 1.3,
                            ),
                          ),
                          20.w.verticalSpace,
                          //* Pick file button
                          Center(
                            child: InkWell(
                              onTap:
                                  (story.isPickingStoryImage ||
                                      story.isPickingStoryVideo)
                                  ? null
                                  : story.pickStoryFile,
                      
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor.withValues(
                                    alpha: 0.45,
                                  ),
                                  borderRadius: BorderRadius.circular(8.w),
                      
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.w,
                                  horizontal: 12.w,
                                ),
                                child: Column(
                                  children: [
                                    if (story.isPickingStoryImage ||
                                        story.isPickingStoryVideo)
                                      SizedBox(
                                        height: 28.wSize,
                                        width: 28.wSize,
                                        child:
                                            const CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: AppColors.primary,
                                              strokeCap: StrokeCap.round,
                                            ),
                                      )
                                    else
                                      Icon(
                                        Icons.upload_file_rounded,
                                        size: 30.wSize,
                                        color: AppColors.primary,
                                      ),
                                    10.w.verticalSpace,
                                    Text(
                                      "Pick file",
                                      style: semiBold(
                                        fontSize: 15.fSize,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    4.w.verticalSpace,
                                    Text(
                                      (hasImage || hasVideo)
                                          ? 'Replace selected file'
                                          : 'Image or video',
                                      textAlign: TextAlign.center,
                                      style: regular(
                                        fontSize: 11.fSize,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.45,
                                        ),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (hasImage || hasVideo) ...[
                            20.w.verticalSpace,
                            Text(
                              'Selected',
                              style: semiBold(
                                fontSize: 13.fSize,
                                color: AppColors.primary.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                            10.w.verticalSpace,
                          ],
                          if (hasImage)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14.w),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.memory(
                                      story.storyContentImageBytes!,
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                        12.w,
                                        28.w,
                                        12.w,
                                        10.w,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            AppColors.black.withValues(
                                              alpha: 0.55,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Text(
                                        story.storyContentImageFile?.name ??
                                            'Image',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: semiBold(
                                          fontSize: 12.fSize,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 8.w,
                                      right: 8.w,
                                    ),
                                    child: Tooltip(
                                      message: 'Remove image',
                                      child: Material(
                                        color: AppColors.white.withValues(
                                          alpha: 0.92,
                                        ),
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.antiAlias,
                                        child: InkWell(
                                          onTap: story.clearStoryContentImage,
                                          customBorder: const CircleBorder(),
                                          child: SizedBox(
                                            width: 26.w,
                                            height: 26.w,
                                            child: Center(
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 14.wSize,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (hasImage && hasVideo) 12.w.verticalSpace,
                          if (hasVideo)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.w),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.92),
                                    AppColors.primary.withValues(alpha: 0.78),
                                  ],
                                ),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.w,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.play_circle_fill_rounded,
                                        color: AppColors.white,
                                        size: 32.wSize,
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            story.storyContentVideoFile!.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: semiBold(
                                              fontSize: 14.fSize,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          if (videoSizeLabel.isNotEmpty) ...[
                                            SizedBox(height: 4.w),
                                            Text(
                                              videoSizeLabel,
                                              style: regular(
                                                fontSize: 12.fSize,
                                                color: AppColors.white
                                                    .withValues(alpha: 0.75),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Remove video',
                                      child: Material(
                                        color: AppColors.white.withValues(
                                          alpha: 0.22,
                                        ),
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.antiAlias,
                                        child: InkWell(
                                          onTap: story.clearStoryContentVideo,
                                          customBorder: const CircleBorder(),
                                          child: SizedBox(
                                            width: 26.w,
                                            height: 26.w,
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: AppColors.white
                                                  .withValues(alpha: 0.95),
                                              size: 14.wSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (!hasImage && !hasVideo) ...[
                            20.w.verticalSpace,
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.touch_app_rounded,
                                    size: 36.wSize,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                  8.w.verticalSpace,
                                  Text(
                                    'Tap Pick file to get started',
                                    style: regular(
                                      fontSize: 13.fSize,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.35,
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
                  ],
                ),
              );
            },
          ),
        ),
        Consumer<StoryProvider>(
          builder: (context, story, _) {
            final upHasImage = story.hasStoryContentImage;
            final upHasVideo = story.hasStoryContentVideo;
            if (!upHasImage && !upHasVideo) {
              return const SizedBox.shrink();
            }
            return Material(
              elevation: 12,
              shadowColor: AppColors.primary.withValues(alpha: 0.12),
              color: AppColors.white,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ready to upload',
                        style: semiBold(
                          fontSize: 13.fSize,
                          color: AppColors.primary,
                        ),
                      ),
                      4.w.verticalSpace,
                      Text(
                        upHasImage && upHasVideo
                            ? 'Your image and video will be sent together.'
                            : upHasImage
                            ? 'Your selected image will be sent.'
                            : 'Your selected video will be sent.',
                        style: regular(
                          fontSize: 11.fSize,
                          color: AppColors.primary.withValues(alpha: 0.48),
                          height: 1.25,
                        ),
                      ),
                      12.w.verticalSpace,
                      AppFilledButton(
                        borderRadius: 12.w,
                        height: 48.w,
                        text: 'Upload story content',
                        onTap: story.isUploadingStoryContent
                            ? () {}
                            : () => story.uploadStoryContent(onSuccess: () {
                              AppToast.success(context: context, message: "Content uploaded successfully");
                            }),
                        child: story.isUploadingStoryContent
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.white,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Uploading…',
                                    style: semiBold(
                                      fontSize: 15.fSize,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
