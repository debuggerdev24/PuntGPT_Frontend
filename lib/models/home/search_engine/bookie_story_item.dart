import 'package:puntgpt_nick/core/constants/app_assets.dart';
import 'package:puntgpt_nick/core/constants/app_strings.dart';

/// Partner “story” shown on the home screen. Add rows here when new logos / ad
/// creatives / URLs are supplied — no other code changes required.
class BookieStoryItem {
  const BookieStoryItem({
    required this.id,
    required this.displayName,
    required this.avatarAsset,
    required this.storyImageAsset,
    required this.affiliateUrl,
  });

  final String id;
  final String displayName;
  final String avatarAsset;
  final String storyImageAsset;
  final String affiliateUrl;
}

const List<BookieStoryItem> kDefaultBookieStories = [
  BookieStoryItem(
    id: 'puntgpt',
    displayName: 'PuntGPT',
    avatarAsset: AppAssets.puntGPTAdsLogo,
    storyImageAsset: AppAssets.puntGPTAdvertisement,
    affiliateUrl: "",
  ),
  BookieStoryItem(
    id: 'dabble',
    displayName: 'Dabble',
    avatarAsset: AppAssets.dabbleLogo,
    storyImageAsset: AppAssets.dabbleAdvertisement,
    affiliateUrl: AppStrings.dabblePartnerUrl,
  ),
  BookieStoryItem(
    id: 'unibat',
    displayName: 'Unibet',
    avatarAsset: AppAssets.unibatLogo,
    storyImageAsset: AppAssets.unibatAdvertisement,
    affiliateUrl: AppStrings.unibetPartnerUrl,
  ),
  
];
