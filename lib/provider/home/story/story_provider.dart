import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/story/story_model.dart';
import 'package:puntgpt_nick/services/story/story_api_service.dart';

class StoryProvider extends ChangeNotifier {
  List<StoryModel>? _stories;
  List<StoryModel>? get stories => _stories;

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _storyContentImageFile, _storyContentVideoFile, _storyDataAvatarFile;
  Uint8List? _storyContentImageBytes;
  int? _storyContentVideoSizeBytes;
  bool _busyStoryImage = false,
      _busyStoryVideo = false,
      _isUploadingStoryContent = false,
      _isUpdatingStoryData = false,
      _isDeletingStoryContent = false,
      _isCreatingStorySection = false;
  String? _deletingStoryContentId;
  bool _isPickingStoryDataAvatar = false;
  String _selectedBookie = "",
      _storyDataDisplayName = "",
      _storyDataAffiliateUrl = "";

  XFile? get storyContentImageFile => _storyContentImageFile;
  Uint8List? get storyContentImageBytes => _storyContentImageBytes;
  XFile? get storyContentVideoFile => _storyContentVideoFile;
  int? get storyContentVideoSizeBytes => _storyContentVideoSizeBytes;
  bool get isPickingStoryImage => _busyStoryImage;
  bool get isPickingStoryVideo => _busyStoryVideo;
  bool get isUploadingStoryContent => _isUploadingStoryContent;
  bool get isUpdatingStoryData => _isUpdatingStoryData;
  bool get isDeletingStoryContent => _isDeletingStoryContent;
  String? get deletingStoryContentId => _deletingStoryContentId;
  bool get isPickingStoryDataAvatar => _isPickingStoryDataAvatar;
  String get selectedStorySection => _selectedBookie;
  String get storyDataDisplayName => _storyDataDisplayName;

  String get storyDataAffiliateUrl => _storyDataAffiliateUrl;
  XFile? get storyDataAvatarFile => _storyDataAvatarFile;

  bool get hasStoryContentImage =>
      _storyContentImageBytes != null && _storyContentImageBytes!.isNotEmpty;
  bool get hasStoryContentVideo =>
      _storyContentVideoFile?.name.isNotEmpty ?? false;

  void selectStorySection(String section) {
    if (!_stories!.any((s) => s.section == section)) return;
    if (_selectedBookie == section) return;
    _selectedBookie = section;
    notifyListeners();
  }

  void setStoryDataDisplayName(String value) {
    if (_storyDataDisplayName == value) return;
    _storyDataDisplayName = value;
  }

  void setStoryDataAffiliateUrl(String value) {
    if (_storyDataAffiliateUrl == value) return;
    _storyDataAffiliateUrl = value;
  }

  Future<void> pickStoryDataAvatar() async {
    if (_isPickingStoryDataAvatar) return;
    _isPickingStoryDataAvatar = true;
    notifyListeners();
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      if (file == null) return;
      _storyDataAvatarFile = file;
    } finally {
      _isPickingStoryDataAvatar = false;
      notifyListeners();
    }
  }

  void clearStoryDataAvatar() {
    if (_storyDataAvatarFile == null) return;
    _storyDataAvatarFile = null;
    notifyListeners();
  }

  String storyContentVideoSizeLabel() {
    final b = _storyContentVideoSizeBytes;
    if (b == null) return '';
    if (b < 1024) return '$b B';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
    return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> pickStoryFile() async {
    if (_busyStoryImage || _busyStoryVideo) return;
    _busyStoryImage = true;
    _busyStoryVideo = true;
    notifyListeners();
    try {
      final x = await _imagePicker.pickMedia();
      if (x == null) return;
      final path = x.path.toLowerCase();
      final isImage =
          path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png') ||
          path.endsWith('.webp') ||
          path.endsWith('.gif') ||
          path.endsWith('.heic');

      if (isImage) {
        final bytes = await x.readAsBytes();
        _storyContentImageFile = x;
        _storyContentImageBytes = bytes;
        _storyContentVideoFile = null;
        _storyContentVideoSizeBytes = null;
        return;
      }

      final len = await x.length();
      _storyContentVideoFile = x;
      _storyContentVideoSizeBytes = len;
      _storyContentImageFile = null;
      _storyContentImageBytes = null;
    } finally {
      _busyStoryImage = false;
      _busyStoryVideo = false;
      notifyListeners();
    }
  }

  void clearStoryContentImage() {
    _storyContentImageFile = null;
    _storyContentImageBytes = null;
    notifyListeners();
  }

  void clearStoryContentVideo() {
    _storyContentVideoFile = null;
    _storyContentVideoSizeBytes = null;
    notifyListeners();
  }

  Future<void> getStories() async {
    final response = await StoryApiService.instance.getStories();
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        _stories = (r).map((e) => StoryModel.fromJson(e)).toList();
        if (_stories != null && _stories!.isNotEmpty) {
          final s = _stories!.first;
          Logger.info('Stories loaded: ${s.title}');
        }
        notifyListeners();
      },
    );
  }

  //* Submits selected draft image/video to the API (payload TBD).
  Future<void> uploadStoryContent({required VoidCallback onSuccess}) async {
    if (_isUploadingStoryContent) return;
    if (!hasStoryContentImage && !hasStoryContentVideo) return;

    _isUploadingStoryContent = true;
    notifyListeners();
    try {
      final section = _selectedBookie;
      final isImage = _storyContentImageFile != null;
      final selectedFile = isImage
          ? _storyContentImageFile
          : _storyContentVideoFile;
      if (selectedFile == null) return;

      final storyContent = FormData.fromMap({
        "section": section,
        "media_type": isImage ? "image" : "video",
        "file": await MultipartFile.fromFile(
          selectedFile.path,
          filename: selectedFile.name,
        ),
      });

      final response = await StoryApiService.instance.uploadStoryContent(
        data: storyContent,
      );
      response.fold((l) => Logger.error(l.errorMsg), (r) {
        Logger.info("Upload Success");
        _storyContentImageFile = null;
        _storyContentImageBytes = null;
        _storyContentVideoFile = null;
        _storyContentVideoSizeBytes = null;
        getStories();
        onSuccess();
      });
    } finally {
      _isUploadingStoryContent = false;
      notifyListeners();
    }
  }

  Future<void> updateStoryData({required VoidCallback onSuccess}) async {
    if (_isUpdatingStoryData) return;

    _isUpdatingStoryData = true;
    notifyListeners();
    try {
      final data = <String, dynamic>{};
      data["display_name"] = _storyDataDisplayName.trim();
      // Send even when empty to allow clearing existing affiliate URL.
      data["affiliate_url"] = _storyDataAffiliateUrl.trim();
      if (_storyDataAvatarFile != null) {
        data["avatar"] = await MultipartFile.fromFile(
          _storyDataAvatarFile!.path,
          filename: _storyDataAvatarFile!.name,
        );
      }

      final response = await StoryApiService.instance.updateStorySection(
        section: _selectedBookie,
        data: FormData.fromMap(data),
      );

      response.fold(
        (l) {
          Logger.error(l.errorMsg);
        },
        (r) {
          Logger.info("Story data updated: $r");
          _storyDataAvatarFile = null;
          onSuccess();
          getStories();
        },
      );
    } finally {
      _isUpdatingStoryData = false;
      notifyListeners();
    }
  }

  Future<void> createStorySection({required VoidCallback onSuccess}) async {
    if (_isCreatingStorySection) return;
    _isCreatingStorySection = true;
    notifyListeners();

    final payload = <String, dynamic>{
      "section": _storyDataDisplayName.toLowerCase(),
      "display_name": _storyDataDisplayName,
      "affiliate_url": _storyDataAffiliateUrl,
    };

    if (_storyDataAvatarFile != null) {
      payload["avatar"] = await MultipartFile.fromFile(
        _storyDataAvatarFile!.path,
        filename: _storyDataAvatarFile!.name,
      );
    }

    final response = await StoryApiService.instance.createStorySection(
      data: FormData.fromMap(payload),
    );
    response.fold((l) => Logger.error(l.errorMsg), (r) {
      Logger.info("Story section created: $r");
      _storyDataAvatarFile = null;
      onSuccess();
      getStories();
    });
    _isCreatingStorySection = false;
    notifyListeners();
  }

  Future<void> deleteStoryContent({
    required String id,
    required VoidCallback onSuccess,
  }) async {
    if (id.isEmpty) return;
    _isDeletingStoryContent = true;
    _deletingStoryContentId = id;
    notifyListeners();
    try {
      final response = await StoryApiService.instance.deleteStoryContent(
        id: id,
      );
      response.fold((l) => Logger.error(l.errorMsg), (_) {
        getStories();
        onSuccess();
      });
    } finally {
      _isDeletingStoryContent = false;
      _deletingStoryContentId = null;
      notifyListeners();
    }
  }

  Future<void> deleteBookie({required VoidCallback onSuccess,required String section}) async {
    final response = await StoryApiService.instance.deleteBookie(
      section: section,
    );
    response.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        Logger.info("Bookie deleted successfully: $r");
        getStories();
        onSuccess();
      },
    );
  }
} /*
    

*/
