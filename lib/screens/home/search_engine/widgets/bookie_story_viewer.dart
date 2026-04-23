import 'package:better_player_plus/better_player_plus.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/story/story_model.dart';
import 'package:url_launcher/url_launcher.dart';


//* Full-screen story: swipe sideways between slides (multiple per channel), tap for link.
class BookieStoryViewer extends StatefulWidget {
  const BookieStoryViewer({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  final List<StoryModel> stories;
  final int initialIndex;

  @override
  State<BookieStoryViewer> createState() => _BookieStoryViewerState();
}

class _BookieStoryViewerState extends State<BookieStoryViewer> {
  late final PageController _pageController;
  late final List<_StorySlide> _slides;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _slides = [];
    for (final story in widget.stories) {
      final images = story.imageAdsList;
      final videos = story.videoAdsList;
      final howManySlides = story.slideCount;
      if (howManySlides == 0) continue;

      for (var slideIndex = 0; slideIndex < howManySlides; slideIndex++) {
        // Use image asset when available, otherwise fallback to story avatar/logo.
        final isImageSlide = slideIndex < images.length;
        // Keep every image as its own slide; append videos after images.
        final imageForSlide = images.isEmpty
            ? story.logo
            : (isImageSlide ? images[slideIndex].url : images.last.url);

        String? videoForSlide;
        if (!isImageSlide) {
          final videoIndex = slideIndex - images.length;
          final path = videos[videoIndex].url.trim();
          if (path.isNotEmpty) videoForSlide = path;
        }

        _slides.add(
          _StorySlide(
            channel: story,
            imageAsset: imageForSlide,
            videoAsset: videoForSlide,
            slideIndexInChannel: slideIndex,
            slideCountInChannel: howManySlides,
          ),
        );
      }
    }

    final lastSlide = _slides.isEmpty ? 0 : _slides.length - 1;
    final channelStart = widget.stories.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, widget.stories.length - 1);
    final startFlat = flatSlideIndexForChannel(widget.stories, channelStart);
    final start = startFlat.clamp(0, lastSlide);

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

  //* Story tap behavior:
  //* - If affiliate URL exists, always open it (including PuntGPT).
  //* - If PuntGPT has no URL configured, fallback to Manage Subscription.
  void _onStoryImageTap(StoryModel story) {
    
    Logger.info('Story section: ${story.section}');
    Logger.info('Story affiliate URL: ${story.affiliateUrl}');
    if (story.section == 'puntgpt') {
      final routeName = (context.isMobileView && kIsWeb)
          ? WebRoutes.manageSubscriptionScreen.name
          : AppRoutes.manageSubscriptionScreen.name;
      Navigator.of(context).pop(_currentPage);
      Future.microtask(() {
        (kIsWeb ? WebRouter.router : AppRouter.router).pushNamed(routeName);
      });
      return;
    }

    final url = story.affiliateUrl.trim();
    if (url.isNotEmpty) {
      _openAffiliateLink(url);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty || _slides.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SegmentProgressRow(
              pageCount: _slides[_currentPage].slideCountInChannel,
              currentPage: _slides[_currentPage].slideIndexInChannel,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 0.w, 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _slides[_currentPage].channel.title,
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
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  final channel = slide.channel;
                  final isActive = i == _currentPage;
                  final videoPath = slide.videoAsset;
                  if (videoPath != null && videoPath.isNotEmpty) {
                    return _StoryVideoPage(
                      key: ValueKey('story-video-${channel.section}-$i-$videoPath'),
                      story: channel,
                      posterAsset: slide.imageAsset,
                      videoAssetPath: videoPath,
                      isActive: isActive,
                      onTapImage: () => _onStoryImageTap(channel),
                      onSwipeDown: _closeAndReturnLastPage,
                    );
                  }
                  return _StoryAdPage(
                    imageAsset: slide.imageAsset,
                    onTapImage: () => _onStoryImageTap(channel),
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



//* One entry in the fullscreen PageView (one image; swipe = next slide or next partner).
class _StorySlide {
  const _StorySlide({
    required this.channel,
    required this.imageAsset,
    this.videoAsset,
    required this.slideIndexInChannel,
    required this.slideCountInChannel,
  });

  final StoryModel channel;
  final String imageAsset;

  /// If set, this slide plays bundled video; otherwise [imageAsset] only.
  final String? videoAsset;

  /// 0-based index within this channel only (for the top progress bar).
  final int slideIndexInChannel;

  /// How many slides this channel has (same on every slide of that channel).
  final int slideCountInChannel;
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
          behavior: HitTestBehavior.opaque,
          child: Image.network(
            "${AppConfig.baseurl}$imageAsset",
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              final expected = progress.expectedTotalBytes;
              final value = (expected == null || expected == 0)
                  ? null
                  : progress.cumulativeBytesLoaded / expected;
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                  value: value,
                  strokeCap: StrokeCap.round,
                ),
              );
            },
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 42,
            ),
          ),
        ),
      ),
    );
  }
}

/// Plays a bundled story video when possible; otherwise shows the first story image.
class _StoryVideoPage extends StatefulWidget {
  const _StoryVideoPage({
    super.key,
    required this.story,
    required this.posterAsset,
    required this.videoAssetPath,
    required this.isActive,
    required this.onTapImage,
    required this.onSwipeDown,
  });

  final StoryModel story;
  final String posterAsset;
  final String videoAssetPath;
  final bool isActive;
  final VoidCallback onTapImage;
  final VoidCallback onSwipeDown;

  @override
  State<_StoryVideoPage> createState() => _StoryVideoPageState();
}

class _StoryVideoPageState extends State<_StoryVideoPage> {
  BetterPlayerController? _player;
  bool _ready = false;
  bool _useImageFallback = false;
  bool _isBuffering = true;

  @override
  void initState() {
    super.initState();
    _bootstrapBetterPlayer();
  }

  void _onBetterPlayerEvent(BetterPlayerEvent event) {
    if (!mounted) return;
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.exception:
        Logger.error('Story BetterPlayer exception: ${event.parameters}');
        _player?.dispose(forceDispose: true);
        _player = null;
        setState(() {
          _ready = false;
          _useImageFallback = true;
        });
        return;
      case BetterPlayerEventType.initialized:
        setState(() => _isBuffering = false);
        if (widget.isActive) {
          _player?.play();
        }
        return;
      case BetterPlayerEventType.bufferingStart:
        setState(() => _isBuffering = true);
        return;
      case BetterPlayerEventType.bufferingEnd:
        setState(() => _isBuffering = false);
        return;
      default:
        return;
    }
  }

  Future<void> _bootstrapBetterPlayer() async {
    if (kIsWeb) {
      if (mounted) setState(() => _useImageFallback = true);
      return;
    }
    try {
      if (!mounted) return;

      final config = BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        // [fit] only applies inside the player’s box. [expandToFill] makes that box fill the parent;
        // otherwise the player stays small and cover looks like it “does nothing”.
        fit: BoxFit.cover,
        expandToFill: false,
        handleLifecycle: true,
        eventListener: _onBetterPlayerEvent,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          showControls: false,
          showControlsOnInitialize: false,
          enableFullscreen: true,
          enableMute: false,
          enableProgressBar: false,
          enablePlayPause: false,
          enableSkips: false,
          enableOverflowMenu: false,
          enablePip: false,
          enableRetry: false,
          enablePlaybackSpeed: false,
          enableSubtitles: false,
          enableQualities: false,
          enableAudioTracks: false,
        ),
      );

      final source = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "${AppConfig.baseurl}${widget.videoAssetPath}",
        notificationConfiguration: const BetterPlayerNotificationConfiguration(
          showNotification: false,
        ),
      );

      _player = BetterPlayerController(config, betterPlayerDataSource: source);
      setState(() => _ready = true);

      if (widget.isActive) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _player?.play();
        });
      }
    } catch (e, st) {
      Logger.error('Story video failed to load: $e\n$st');
      if (!mounted) return;
      setState(() => _useImageFallback = true);
    }
  }

  Future<void> _applyPlayPauseForVisibility() async {
    final p = _player;
    if (p == null) return;
    if (widget.isActive) {
      await p.seekTo(Duration.zero);
      await p.play();
    } else {
      await p.pause();
    }
  }

  @override
  void didUpdateWidget(covariant _StoryVideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive && _player != null) {
      _applyPlayPauseForVisibility();
    }
  }

  @override
  void dispose() {
    _player?.dispose(forceDispose: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useImageFallback) {
      return _StoryAdPage(
        imageAsset: widget.posterAsset,
        onTapImage: widget.onTapImage,
        onSwipeDown: widget.onSwipeDown,
      );
    }
    if (!_ready || _player == null) {
      return GestureDetector(
        onVerticalDragEnd: (details) {
          final v = details.primaryVelocity ?? 0;
          if (v > 300) widget.onSwipeDown();
        },
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white70, strokeCap: StrokeCap.round),
        ),
      );
    }

    return GestureDetector(
      onVerticalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v > 300) widget.onSwipeDown();
      },
      child: GestureDetector(
        onTap: widget.onTapImage,
        behavior: HitTestBehavior.opaque,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: Colors.black),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: ClipRect(
                    // ← Add ClipRect
                    child: OverflowBox(
                      // ← Wrap with OverflowBox
                      maxWidth: constraints.maxWidth,
                      maxHeight: constraints.maxHeight,
                      child: BetterPlayer(controller: _player!),
                    ),
                  ),
                  // child: BetterPlayer(controller: _player!),
                ),
                if (_isBuffering)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white70, strokeCap: StrokeCap.round),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
