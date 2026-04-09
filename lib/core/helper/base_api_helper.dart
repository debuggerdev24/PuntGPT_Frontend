import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/end_points.dart';
import '../router/app/app_routes.dart';
import '../router/app/app_router.dart';
import '../router/web/web_router.dart';
import '../../services/storage/locale_storage_service.dart';
import '../constants/app_config.dart';
import 'log_helper.dart';

class DioClient {
  factory DioClient() => _instance;
  DioClient._internal() {
    final baseOptions = BaseOptions(baseUrl: AppConfig.apiBaseurl);
    Logger.info("API Base URL: ${AppConfig.apiBaseurl}");
    dio = Dio(baseOptions);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = LocaleStorageService.acccessToken;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          final requestOptions = error.requestOptions;

          final shouldSkip = requestOptions.extra['skipAuthRefresh'] == true;
          final isRefreshCall = requestOptions.path.contains(EndPoints.refreshToken);
          final alreadyRetried = requestOptions.extra['__retried_after_refresh'] == true;

          // Only attempt refresh on token-expired 401, and never for the refresh endpoint itself.
          if (status != 401 || shouldSkip || isRefreshCall || alreadyRetried) {
            return handler.next(error);
          }

          final data = error.response?.data;
          final tokenNotValid =
              data is Map && (data['code']?.toString() == 'token_not_valid');
          if (!tokenNotValid) return handler.next(error);

          //* If we don't have a refresh token, there's nothing to do.
          if (LocaleStorageService.refreshToken.isEmpty) {
            await _logoutAndGoToLogin();
            return handler.next(error);
          }

          try {
            final refreshed = await _refreshAccessTokenOnce();
            if (!refreshed) {
              await _logoutAndGoToLogin();
              return handler.next(error);
            }

            // Retry the original request with the new access token.
            final newAccessToken = LocaleStorageService.acccessToken;
            final retryOptions = requestOptions..extra['__retried_after_refresh'] = true;
            retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final response = await dio.fetch(retryOptions);
            return handler.resolve(response);
          } catch (e, st) {
            Logger.error('[DioClient] Refresh+retry failed: $e\n$st');
            return handler.next(error);
          }
        },
      ),
    );
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  /// Ensures only a single refresh call runs at a time.
  Completer<bool>? _refreshCompleter;

  Future<void> _logoutAndGoToLogin() async {
    await LocaleStorageService.clearUserTokens();
    // Keep it simple: go to onboarding (login flow starts from there).
    (kIsWeb ? WebRouter.router : AppRouter.router)
        .goNamed(AppRoutes.onboardingScreen.name);
  }

  Future<bool> _refreshAccessTokenOnce() async {
    if (_refreshCompleter != null) return _refreshCompleter!.future;

    _refreshCompleter = Completer<bool>();
    try {
      final refresh = LocaleStorageService.refreshToken;
      if (refresh.isEmpty) {
        _refreshCompleter!.complete(false);
        return _refreshCompleter!.future;
      }

      // Use a separate Dio instance to avoid interceptor loops.
      final refreshDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseurl));
      final res = await refreshDio.post<Map<String, dynamic>>(
        EndPoints.refreshToken,
        data: {"refresh": refresh},
        options: Options(extra: const {"skipAuthRefresh": true}),
      );

      final data = res.data ?? const <String, dynamic>{};
      final newAccess = data["access"]?.toString() ?? '';
      if (newAccess.isEmpty) {
        _refreshCompleter!.complete(false);
        return _refreshCompleter!.future;
      }

      await LocaleStorageService.saveUserToken(newAccess);
      _refreshCompleter!.complete(true);
      return _refreshCompleter!.future;
    } catch (e, st) {
      Logger.error('[DioClient] Refresh token call failed: $e\n$st');
      _refreshCompleter!.complete(false);
      return _refreshCompleter!.future;
    } finally {
      _refreshCompleter = null;
    }
  }
}

class BaseApiHelper {
  BaseApiHelper._();
  static final BaseApiHelper _instance = BaseApiHelper._();
  static BaseApiHelper get instance => _instance;
  final Dio _dio = DioClient().dio;
  Future<Either<ApiException, T>> get<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      // final result = _handleResponse(response);
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      return Left(
        ApiException(
          errorMsg: _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          apiErrorMsg: e.message,
        ),
      );
    } on Exception catch (e) {
      return Left(
        ApiException(
          errorMsg: 'Somethign went wrong',
          apiErrorMsg: e.toString(),
          code: '',
        ),
      );
    }
  }

  Future<Either<ApiException, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      // Fallback for other errors
      return Left(
        ApiException(
          errorMsg: _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          apiErrorMsg: e.message,
        ),
      );
    } catch (e) {
      Logger.error(":x: Exception: $e");
      return Left(
        ApiException(
          errorMsg: 'Something went wrong',
          code: '',
          apiErrorMsg: e.toString(),
        ),
      );
    }
  }

  Future<Either<ApiException, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      return Left(
        ApiException(
          errorMsg: _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          apiErrorMsg: e.message,
        ),
      );
    } catch (e) {
      Logger.error(":x: Exception: $e");
      return Left(
        ApiException(
          errorMsg: 'Something went wrong',
          code: '',
          apiErrorMsg: e.toString(),
        ),
      );
    }
  }

  Future<Either<ApiException, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      return Left(
        ApiException(
          errorMsg: _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          apiErrorMsg: e.message,
        ),
      );
    } catch (e) {
      Logger.error(":x: Exception: $e");
      return Left(
        ApiException(
          errorMsg: 'Something went wrong',
          code: '',
          apiErrorMsg: e.toString(),
        ),
      );
    }
  }

  // Future<Either<ApiException, bool>> checkTokenExpired() async {
  //   try {
  //     final response = await _dio.get(EndPoints.checkTokenExpired);
  //     final result = response.data;
  //     Logger.info("inside try section -> ${result["messages"].toString()}");
  //     if (result['details'] == "token_not_valid") {
  //       Logger.info("expired");
  //       return Right(true);
  //     } else {
  //       return Right(false);
  //     }
  //   } on DioException catch (e) {
  //     return Right(false);
  //   } catch (e) {
  //     Logger.error(":x: Exception: $e");
  //     return Right(false);
  //   }
  // }

  // Future<Either<ApiException, void>> refreshAuthToken() async {
  //   Logger.info(
  //     "refresh auth token : ${LocaleStoaregService.userRefreshToken}",
  //   );
  //   var data = FormData.fromMap({
  //     'refresh': LocaleStoaregService.userRefreshToken,
  //   });
  //   try {
  //     final response = await _dio.post(Endpoints.refreshToken, data: data);
  //     final result = response.data;
  //     if (result["code"] == token_not_valid) {
  //       return Left(
  //         ApiException(
  //           'Token is expired',
  //           code: '0',
  //           originalErrorMessage: 'Token is expired',
  //         ),
  //       );
  //     } else {
  //       final newToken = result["access"];
  //       // await LocaleStoaregService.saveUserToken(newToken);
  //     }
  //     return Right(null);
  //   } on DioException catch (e) {
  //     return Left(
  //       ApiException(
  //         _handleErrorMessage(e),
  //         code: e.response!.data["code"],
  //         originalErrorMessage: e.message,
  //       ),
  //     );
  //   } catch (e) {
  //     Logger.info(":x: Exception: $e");
  //     return Left(
  //       ApiException(
  //         'Something went wrong',
  //         code: '',
  //         originalErrorMessage: e.toString(),
  //       ),
  //     );
  //   }
  // }

  String _handleErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timed out';
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    }
    if (e.response != null) {
      final data = e.response?.data;
      if (e.response?.statusCode == 400) {
        if (data is Map) {
          final errorContent = data['error'] ?? data['errors'];
          // If we found 'error' or 'errors' and it's a map
          if (errorContent is Map && errorContent.isNotEmpty) {
            final firstKey = errorContent.keys.first;
            Logger.info("[Base Api Helper] --- first key: $firstKey");
            final errorValue = errorContent[firstKey];
            if (errorValue is List && errorValue.isNotEmpty) {
              return errorValue.first.toString();
            } else if (errorValue is String) {
              return errorValue;
            }
          }
          // If 'message' exists
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
          // Try generic key-based parsing (Django/DRF style)
          final firstKey = data.keys.firstOrNull;
          final errorList = data[firstKey];
          if (errorList is List && errorList.isNotEmpty) {
            return errorList.first.toString();
          }
        } else if (data is String) {
          return data;
        }
        return 'Invalid request (400)';
      } else if (e.response?.statusCode == 401) {
        return 'Unauthorized. Please log in again.';
      }
      return data[1] ?? 'Unexpected server response';
    }
    return e.message ?? 'Unknown error occurred';
  }
}

class ApiException implements Exception {
  ApiException({required this.errorMsg, required this.code, this.apiErrorMsg});
  final String errorMsg;
  final String? code;
  final String? apiErrorMsg;
  @override
  String toString() {
    return "api error: $errorMsg ----- status code: $code";
  }
}
