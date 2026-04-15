import 'package:puntgpt_nick/core/constants/app_assets.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';

/// Partner “story” on the home screen — one row per partner in [kDefaultBookieStories].
///
/// **Slides:** [storyImageAssets] is the only list you edit — 1 path = one slide,
/// left to right swipe order. Same [affiliateUrl] / [id] for the whole channel.
class BookieStoryItem {
  const BookieStoryItem({
    required this.id,
    required this.displayName,
    required this.avatarAsset,
    required this.storyImageAssets,
    required this.affiliateUrl,
    this.storyVideoAsset,
  });

  final String id;
  final String displayName;
  final String avatarAsset;

  /// Fullscreen images only — add/remove strings here (at least one).
  final List<String> storyImageAssets;

  final String affiliateUrl;

  /// First slide only: if set, tries to play this video (loops); else shows images.
  final String? storyVideoAsset;
}

/// Flat PageView index when user tapped avatar at [channelIndex].
int flatSlideIndexForChannel(List<BookieStoryItem> stories, int channelIndex) {
  var sum = 0;
  for (var i = 0; i < channelIndex && i < stories.length; i++) {
    sum += stories[i].storyImageAssets.length;
  }
  return sum;
}

/// Partner ids touched between two flat slide indices (inclusive).
Set<String> channelIdsInFlatPageRange(
  List<BookieStoryItem> stories,
  int flatA,
  int flatB,
) {
  final lo = flatA < flatB ? flatA : flatB;
  final hi = flatA < flatB ? flatB : flatA;
  final ids = <String>{};
  var flat = 0;
  for (final s in stories) {
    final len = s.storyImageAssets.length;
    final start = flat;
    final end = flat + len - 1;
    if (end >= lo && start <= hi) {
      ids.add(s.id);
    }
    flat += len;
  }
  return ids;
}

const List<BookieStoryItem> kDefaultBookieStories = [
  BookieStoryItem(
    id: 'puntgpt',
    displayName: 'PuntGPT',
    avatarAsset: AppAssets.puntGPTAdsLogo,
    storyImageAssets: [AppAssets.puntGPTAdvertisement],
    storyVideoAsset: AppAssets.puntGPTVideoAds,
    affiliateUrl: "",
  ),
  BookieStoryItem(
    id: 'dabble',
    displayName: 'Dabble',
    avatarAsset: AppAssets.dabbleLogo,
    storyImageAssets: [
      AppAssets.dabbleAdvertisement1,
      AppAssets.dabbleAdvertisement2,
      AppAssets.dabbleAdvertisement3,
    ],
    affiliateUrl: AppStrings.dabblePartnerUrl,
  ),
  BookieStoryItem(
    id: 'unibat',
    displayName: 'Unibet',
    avatarAsset: AppAssets.unibatLogo,
    storyImageAssets: [
      AppAssets.unibatAdvertisement1,
      AppAssets.unibatAdvertisement2,
      AppAssets.unibatAdvertisement3,
    ],
    affiliateUrl: AppStrings.unibetPartnerUrl,
  ),
];
