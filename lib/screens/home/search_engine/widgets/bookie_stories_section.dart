import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';
import 'package:puntgpt_nick/models/home/search_engine/bookie_story_item.dart';
import 'package:puntgpt_nick/screens/home/search_engine/widgets/bookie_story_viewer.dart';

class BookieStoriesSection extends StatefulWidget {
  const BookieStoriesSection({
    super.key,
    this.stories = kDefaultBookieStories,
    this.horizontalPadding = 0,
  });

  final List<BookieStoryItem> stories;
  final double horizontalPadding;

  @override
  State<BookieStoriesSection> createState() => _BookieStoriesSectionState();
}

class _BookieStoriesSectionState extends State<BookieStoriesSection> {
  /// Story ids the user has already opened (so we show the grey ring).
  final Set<String> _seenStoryIds = {};

  /// Opens the viewer at [startIndex]. When it closes, we mark every story
  /// between that index and the last page they were on as “seen”.
  Future<void> _onAvatarTapped(int startIndex) async {
    final list = widget.stories;
    final lastPageIndex = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        fullscreenDialog: true,
        builder: (_) =>
            BookieStoryViewer(stories: list, initialIndex: startIndex),
      ),
    );

    if (!mounted) return;

    // Flat page indices: one swipe can move across several slides and partners.
    final startFlat = flatSlideIndexForChannel(list, startIndex);
    final endFlat = lastPageIndex ?? startFlat;

    setState(() {
      _seenStoryIds.addAll(channelIdsInFlatPageRange(list, startFlat, endFlat));
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.stories;
    if (list.isEmpty) return const SizedBox.shrink();

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
          SizedBox(
            height: avatarSize ,//+22
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: list.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),

              itemBuilder: (context, index) {
                final story = list[index];
                final isUnseen = !_seenStoryIds.contains(story.id);
                return _StoryAvatar(
                  story: story,
                  size: avatarSize,
                  nameFontSize: 11.sp,
                  isUnseen: isUnseen,
                  onTap: () => _onAvatarTapped(index),
                );
              },
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

  final BookieStoryItem story;
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
              border: Border.all(
                color: isUnseen
                    ? AppColors.black
                    : AppColors.primary.withValues(alpha: 0.25),
                width: isUnseen ? 3 : 1.5,
              ),
            ),
            child: ClipOval(
              child: Image.asset(story.avatarAsset, fit: BoxFit.cover),
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
