import 'package:dartz/dartz.dart';
import 'package:puntgpt_nick/core/constants/end_points.dart';
import 'package:puntgpt_nick/core/helper/base_api_helper.dart';

class StoryApiService {
  factory StoryApiService() => _instance;
  StoryApiService._internal();
  static final StoryApiService _instance = StoryApiService._internal();

  static StoryApiService get instance => _instance;

  Future<Either<ApiException, List>> getStories() async {
    return await BaseApiHelper.instance.get(EndPoints.getStory);
  }

  Future<Either<ApiException, Map<String, dynamic>>> uploadStoryContent({
    required dynamic data,
  }) async {
    return await BaseApiHelper.instance.post(
      EndPoints.updateStoryContent,
      data: data,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> updateStorySection({
    required String section,
    required dynamic data,
  }) async {
    return await BaseApiHelper.instance.patch(
      EndPoints.updateStorySection(section: section),
      data: data,
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> createStorySection({
    required dynamic data,
  }) async {
    return await BaseApiHelper.instance.post(
      EndPoints.createStorySection,
      data: data,
    );
  }

  Future<Either<ApiException, bool>> deleteStoryContent({
    required String id,
  }) async {
    return await BaseApiHelper.instance.delete<bool>(
      EndPoints.deleteMedia(id: id),
      parser: (_) => true,
    );
  }
}
