import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/story/story_model.dart';
import 'package:puntgpt_nick/provider/home/story/story_provider.dart';

/// Admin: remove uploaded image/video assets for the selected story section.
class DeleteStoryContent extends StatefulWidget {
  const DeleteStoryContent({super.key});

  @override
  State<DeleteStoryContent> createState() => _DeleteStoryContentState();
}

class _DeleteStoryContentState extends State<DeleteStoryContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppScreenTopBar(
          title: 'Delete story content',
          slogan: 'Remove images or videos for this section',
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: context.read<StoryProvider>(),
            builder: (context, _) {
              final provider = context.read<StoryProvider>();
              final section = provider.selectedStorySection;
              final stories = provider.stories;
              final story = _storyForSection(section, stories);

              if (stories == null) {
                return const _DeleteStoryContentShimmer();
              }

              final images = story?.imageAdsList ?? const <ContentModel>[];
              final videos = story?.videoAdsList ?? const <ContentModel>[];
              final hasAny = images.isNotEmpty || videos.isNotEmpty;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
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
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Text(
                          "Section: ${section.toUpperCase()}",
                          style: semiBold(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    16.w.verticalSpace,
                    if (!hasAny)
                      Container(
                        padding: EdgeInsets.all(20.w),
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
                        child: Text(
                          story == null
                              ? 'No story data for this section yet.'
                              : 'No uploaded images or videos for this section.',
                          style: regular(
                            fontSize: 14.sp,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    else ...[
                      ...images
                          .where((c) => c.id.isNotEmpty)
                          .map(
                            (c) => _ContentDeleteRow(
                              contentType: 'Image',
                              isVideo: false,
                              url: c.url,
                              busy:
                                  provider.isDeletingStoryContent &&
                                  provider.deletingStoryContentId == c.id,
                              onDelete: () => _confirmAndDelete(
                                provider: provider,
                                contentId: c.id,
                                label: 'this image',
                              ),
                            ),
                          ),
                      ...videos
                          .where((c) => c.id.isNotEmpty)
                          .map(
                            (c) => _ContentDeleteRow(
                              contentType: 'Video',
                              isVideo: true,
                              url: c.url,
                              busy:
                                  provider.isDeletingStoryContent &&
                                  provider.deletingStoryContentId == c.id,
                              onDelete: () => _confirmAndDelete(
                                provider: provider,
                                contentId: c.id,
                                label: "this video",
                              ),
                            ),
                          ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  StoryModel? _storyForSection(String section, List<StoryModel>? stories) {
    if (stories == null) return null;
    for (final s in stories) {
      if (s.section == section) return s;
    }
    return null;
  }

  Future<void> _confirmAndDelete({
    required StoryProvider provider,
    required String contentId,
    required String label,
  }) async {
    if (contentId.isEmpty) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.backGroundColor,
          title: Text(
            'Remove $label?',
            style: semiBold(fontSize: 17.sp, color: AppColors.primary),
          ),
          content: Text(
            'This removes the file from the story. You can upload again later.',
            style: regular(
              fontSize: 14.sp,
              color: AppColors.primary.withValues(alpha: 0.65),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(
                'Cancel',
                style: semiBold(fontSize: 14.sp, color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text(
                'Delete',
                style: semiBold(fontSize: 14.sp, color: AppColors.red),
              ),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;

    await provider.deleteStoryContent(
      id: contentId,
      onSuccess: () {
        if (!mounted) return;
        AppToast.success(context: context, message: 'Story content removed');
      },
    );
  }
}

class _ContentDeleteRow extends StatelessWidget {
  const _ContentDeleteRow({
    required this.contentType,
    required this.isVideo,
    required this.url,
    required this.busy,
    required this.onDelete,
  });

  final String contentType;
  final bool isVideo;
  final String url;
  final bool busy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final preview = url.trim().isEmpty ? '—' : url.trim();
    final thumbSize = 88.w;
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.fromLTRB(12.w, 12.w, 4.w, 12.w),
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
      child: Row(
        crossAxisAlignment: .center,
        children: [
          if (!isVideo) ...[
            _StoryImageThumb(pathOrUrl: url, size: thumbSize),
            SizedBox(width: 12.w),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contentType,
                  style: semiBold(fontSize: 16.sp, color: AppColors.primary),
                ),
                4.w.verticalSpace,
                Text(
                  preview.split('/').last,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: regular(
                    fontSize: 12.sp,
                    color: AppColors.primary.withValues(alpha: 0.5),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          busy
              ? Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.red,
                    size: 26.wSize,
                  ),
                ),
        ],
      ),
    );
  }
}

String _absoluteStoryMediaUrl(String pathOrUrl) {
  final t = pathOrUrl.trim();
  if (t.isEmpty) return '';
  if (t.startsWith('http://') || t.startsWith('https://')) return t;
  return '${AppConfig.baseurl}$t';
}

class _StoryImageThumb extends StatelessWidget {
  const _StoryImageThumb({required this.pathOrUrl, required this.size});

  final String pathOrUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final abs = _absoluteStoryMediaUrl(pathOrUrl);
    final radius = BorderRadius.circular(10.w);
    if (abs.isEmpty) {
      return _imageThumbPlaceholder(size: size, radius: radius, child: null);
    }
    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        abs,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imageThumbPlaceholder(
          size: size,
          radius: radius,
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.primary.withValues(alpha: 0.35),
            size: 28.wSize,
          ),
        ),
      ),
    );
  }
}

Widget _imageThumbPlaceholder({
  required double size,
  required BorderRadius radius,
  required Widget? child,
}) {
  return ClipRRect(
    borderRadius: radius,
    child: Container(
      width: size,
      height: size,
      color: AppColors.greyColor.withValues(alpha: 0.45),
      alignment: Alignment.center,
      child: child,
    ),
  );
}

//* Skeleton matching loaded layout: section chip, image row (thumb + text + delete), video row (text + delete).
class _DeleteStoryContentShimmer extends StatelessWidget {
  const _DeleteStoryContentShimmer();

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.w),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final thumbSize = 88.w;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 118.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.w),
                ),
              ),
            ),
            16.w.verticalSpace,
            _shimmerCard(showThumb: true, thumbSize: thumbSize),
            _shimmerCard(showThumb: false, thumbSize: thumbSize),
            _shimmerCard(showThumb: false, thumbSize: thumbSize),
            _shimmerCard(showThumb: false, thumbSize: thumbSize),
            _shimmerCard(showThumb: false, thumbSize: thumbSize),
            _shimmerCard(showThumb: false, thumbSize: thumbSize),
            _shimmerCard(showThumb: false, thumbSize: thumbSize),
            _shimmerCard(showThumb: false, thumbSize: thumbSize),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard({required bool showThumb, required double thumbSize}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.fromLTRB(12.w, 12.w, 4.w, 12.w),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showThumb) ...[
            Container(
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.w),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14.sp,
                  width: 64.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                ),
                8.w.verticalSpace,
                FractionallySizedBox(
                  widthFactor: 0.92,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 12.sp,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ),
                6.w.verticalSpace,
                FractionallySizedBox(
                  widthFactor: 0.58,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 48.w,
            height: 48.w,
            child: Center(
              child: Container(
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
