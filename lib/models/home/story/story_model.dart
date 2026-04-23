class StoryModel {
  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
    id: json["id"],
    section: json["section"],
    title: json["display_name"],
    logo: json["avatar"],
    affiliateUrl: json["affiliate_url"] ?? "",
    videoAdsList: (json["storyVideoAssets"] as List)
        .map((e) => ContentModel.fromJson(e))
        .toList(),
    imageAdsList: (json["storyImageAssets"] as List)
        .map((e) => ContentModel.fromJson(e))
        .toList(),
  );

  StoryModel({
    required this.section,
    required this.title,
    required this.affiliateUrl,
    required this.logo,
    required this.videoAdsList,
    required this.imageAdsList,
    required this.id,
  });

  final String section, title, logo, affiliateUrl;
  final int id;

  /// API: `[{ "id": 1, "url": "/media/..." }]` or `[]`.
  final List<ContentModel> videoAdsList, imageAdsList;

  int get slideCount {
    final nImages = imageAdsList.length;
    final nVideos = videoAdsList.length;
    if (nImages == 0) return nVideos;
    if (nVideos == 0) return nImages;
    // Show all images and all videos as separate slides.
    return nImages + nVideos;
  }
}

/// One row from `storyImageAssets` / `storyVideoAssets` (`id` + `url`).
class ContentModel {
  ContentModel({required this.id, required this.url});

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
    id: _idToString(json['id']),
    url: json['url'] is String ? (json['url'] as String).trim() : '',
  );

  static String _idToString(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is num) return v.toString();
    return '';
  }

  final String id;
  final String url;
}

/// Returns the starting flat PageView index for a given story channel.
/// It sums slide counts of all channels before [channelIndex].
int flatSlideIndexForChannel(List<StoryModel> stories, int channelIndex) {
  var sum = 0;
  for (var i = 0; i < channelIndex && i < stories.length; i++) {
    sum += stories[i].slideCount;
  }
  return sum;
}

//* Partner ids touched between two flat slide indices (inclusive).
Set<String> channelIdsInFlatPageRange(
  List<StoryModel> stories,
  int flatA,
  int flatB,
) {
  final lo = flatA < flatB ? flatA : flatB;
  final hi = flatA < flatB ? flatB : flatA;
  final ids = <String>{};
  var flat = 0;
  for (final s in stories) {
    final len = s.slideCount;
    final start = flat;
    final end = flat + len - 1;
    if (end >= lo && start <= hi) {
      ids.add(s.section);
    }
    flat += len;
  }
  return ids;
}
