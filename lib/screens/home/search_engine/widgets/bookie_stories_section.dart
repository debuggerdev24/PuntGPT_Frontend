import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/models/home/story/story_model.dart';
import 'package:puntgpt_nick/screens/home/search_engine/widgets/bookie_story_viewer.dart';

class BookieStoriesSection extends StatefulWidget {
  const BookieStoriesSection({
    super.key,
    this.stories,
    this.horizontalPadding = 0,
  });

  final List<StoryModel>? stories;
  final double horizontalPadding;

  @override
  State<BookieStoriesSection> createState() => _BookieStoriesSectionState();
}

class _BookieStoriesSectionState extends State<BookieStoriesSection> {
  /// Story ids the user has already opened (so we show the grey ring).
  final Set<String> _seenStoryIds = {};

  /// Opens the viewer at [selectedIndex]. When it closes, we mark every story
  /// between that index and the last page they were on as “seen”.
  Future<void> _onAvatarTapped(int selectedIndex) async {
    final list = widget.stories;
    if (list == null || list.isEmpty) return;

    final tapped = list[selectedIndex];
    if (tapped.slideCount == 0) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: AppColors.backGroundColor,
            title: Text(
              'No story added',
              style: semiBold(fontSize: 17.sp, color: AppColors.primary),
            ),
            content: Text(
              '${tapped.title} has no story images or videos yet. ',
              style: regular(
                fontSize: 14.sp,
                color: AppColors.primary.withValues(alpha: 0.65),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'OK',
                  style: semiBold(fontSize: 14.fSize, color: AppColors.primary),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    final lastPageIndex = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        fullscreenDialog: true,
        builder: (_) =>
            BookieStoryViewer(stories: list, initialIndex: selectedIndex),
      ),
    );

    if (!mounted) return;

    // Flat page indices: one swipe can move across several slides and partners.
    final startFlat = flatSlideIndexForChannel(list, selectedIndex);
    final endFlat = lastPageIndex ?? startFlat;

    setState(() {
      _seenStoryIds.addAll(channelIdsInFlatPageRange(list, startFlat, endFlat));
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.stories;

    if (list == null || list.isEmpty) return const SizedBox.shrink();

    final avatarSize = 64.w;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          5.w.verticalSpace,
          Text(
            AppStrings.safeGamblingStoryBanner,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
              height: 1.25,
              color: AppColors.primary.withValues(alpha: 0.75),
            ),
          ),
          12.w.verticalSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: avatarSize, //+22
              child: Row(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  
                    itemBuilder: (context, index) {
                      final story = list[index];
                      final isUnseen = !_seenStoryIds.contains(story.section);
                      return _StoryAvatar(
                        story: story,
                        size: avatarSize,
                        nameFontSize: 11.sp,
                        isUnseen: isUnseen ,

                        onTap: () => _onAvatarTapped(index),
                      );
                    },
                  ),
                  //* Edit story button
                  InkWell(
                    onTap: () {
                      context.pushNamed(AppRoutes.bookieSelection.name);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.w,
                      ),
                      margin: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
            
                        border: Border.all(
                          color: AppColors.primary,
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        spacing: 4.w,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: AppColors.primary,
                            size: context.isMobileWeb ? 28.sp : 18.sp,
                          ),
            
                          Text(
                            "Edit Story",
                            style: semiBold(
                              fontSize: context.isMobileWeb ? 20.sp : 12.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
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
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({
    required this.story,
    required this.size,
    required this.nameFontSize,
    required this.isUnseen,
    required this.onTap,
  });

  final StoryModel story;
  final double size;
  final double nameFontSize;
  final bool isUnseen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: 
              (story.slideCount == 0) ? null :
              Border.all(
                color: isUnseen
                    ? AppColors.black
                    : AppColors.primary.withValues(alpha: 0.25),
                width: isUnseen ? 3 : 1.5,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                story.logo,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  final expected = loadingProgress.expectedTotalBytes;
                  final value = (expected == null || expected == 0)
                      ? null
                      : loadingProgress.cumulativeBytesLoaded / expected;
                  return Center(
                    child: SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                        value: value,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Colors.black12,
                  child: Icon(Icons.broken_image_outlined, color: Colors.black38),
                ),
              ),
            ),
          ),
          //   SizedBox(height: 6.h),
          //   SizedBox(
          //     width: size + 8,
          //     child: Text(
          //       story.displayName,
          //       textAlign: TextAlign.center,
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //       style: medium(
          //         fontSize: nameFontSize,
          //         color: AppColors.primary.withValues(alpha: 0.85),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
