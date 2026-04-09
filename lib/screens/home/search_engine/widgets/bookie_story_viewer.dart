import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/bookie_story_item.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen story: swipe sideways between partners, tap the ad image for the
/// affiliate link, swipe down or tap X to close. Returns the last page index.
class BookieStoryViewer extends StatefulWidget {
  const BookieStoryViewer({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  final List<BookieStoryItem> stories;
  final int initialIndex;

  @override
  State<BookieStoryViewer> createState() => _BookieStoryViewerState();
}

class _BookieStoryViewerState extends State<BookieStoryViewer> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    final last = widget.stories.length - 1;
    final start = last < 0 ? 0 : widget.initialIndex.clamp(0, last);
    _currentPage = start;
    _pageController = PageController(initialPage: start);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _closeAndReturnLastPage() {
    Navigator.of(context).pop(_currentPage);
  }

  Future<void> _openAffiliateLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  //*
  // First story (PuntGPT, `id: puntgpt`): open Manage Subscription instead of a URL.
  void _onStoryImageTap(BookieStoryItem story) {
    if (story.id == 'puntgpt') {
      final routeName = (context.isMobileView && kIsWeb)
          ? WebRoutes.manageSubscriptionScreen.name
          : AppRoutes.manageSubscriptionScreen.name;
      Navigator.of(context).pop(_currentPage);
      Future.microtask(() {
        (kIsWeb ? WebRouter.router : AppRouter.router).pushNamed(routeName);
      });
      return;
    }
    final url = story.affiliateUrl;
    if (url.isEmpty) return;
    _openAffiliateLink(url);
  }

  @override
  Widget build(BuildContext context) {
    final stories = widget.stories;
    if (stories.isEmpty) return const SizedBox.shrink();

    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SegmentProgressRow(
              pageCount: stories.length,
              currentPage: _currentPage,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      stories[_currentPage].displayName,
                      style: bold(fontSize: 15, color: AppColors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: _closeAndReturnLastPage,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: stories.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  final story = stories[i];
                  return _StoryAdPage(
                    imageAsset: story.storyImageAsset,
                    onTapImage: () => _onStoryImageTap(story),
                    onSwipeDown: _closeAndReturnLastPage,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White bars at the top: filled up to and including the active page.
class _SegmentProgressRow extends StatelessWidget {
  const _SegmentProgressRow({
    required this.pageCount,
    required this.currentPage,
  });

  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Row(
        children: List.generate(pageCount, (i) {
          final isDoneOrActive = i <= currentPage;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: isDoneOrActive ? Colors.white : Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// One fullscreen ad: tap opens URL; fling down closes the viewer.
class _StoryAdPage extends StatelessWidget {
  const _StoryAdPage({
    required this.imageAsset,
    required this.onTapImage,
    required this.onSwipeDown,
  });

  final String imageAsset;
  final VoidCallback onTapImage;
  final VoidCallback onSwipeDown;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v > 300) onSwipeDown();
      },
      child: Center(
        child: GestureDetector(
          onTap: onTapImage,
          child: Image.asset(
            imageAsset,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
