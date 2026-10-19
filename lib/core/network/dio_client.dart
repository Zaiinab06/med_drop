import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:med_drop/core/constants/app_constants.dart';

/// Configures and exposes a [Dio] instance for the entire app.
///
/// Responsibilities:
/// - Base URL & timeout configuration
/// - Default Accept / Content-Type headers
/// - Request-logging interceptor (debug builds only)
/// - Auth-token injection interceptor stub (filled in once auth is wired up)
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    _addInterceptors();
  }

  /// The configured [Dio] instance. Use this for all HTTP calls.
  Dio get dio => _dio;

  // ── Private helpers ──────────────────────────────────────────────────────

  void _addInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(_LoggingInterceptor());
    }
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());
  }
}

// ── Interceptors ─────────────────────────────────────────────────────────────

/// Logs every request / response / error in debug builds.
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
      '[DioClient] ➡️  ${options.method} ${options.uri}\n'
      '  Headers: ${options.headers}\n'
      '  Data: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      '[DioClient] ✅ ${response.statusCode} ${response.requestOptions.uri}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '[DioClient] ❌ ${err.response?.statusCode} '
      '${err.requestOptions.uri}\n  ${err.message}',
    );
    super.onError(err, handler);
  }
}

/// Attaches the Supabase/JWT auth token to every request.
///
/// Populate [_accessToken] once the auth session is established.
class _AuthInterceptor extends Interceptor {
  String? _accessToken;

  /// Call this after the user signs in to start sending the Bearer token.
  // ignore: use_setters_to_change_properties
  void updateToken(String token) => _accessToken = token;

  /// Call this on sign-out to stop sending the token.
  void clearToken() => _accessToken = null;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

/// Converts Dio errors into structured [DioException]s with a unified message.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = switch (err.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out.',
      DioExceptionType.receiveTimeout => 'Server took too long to respond.',
      DioExceptionType.sendTimeout => 'Request upload timed out.',
      DioExceptionType.connectionError => 'No internet connection.',
      DioExceptionType.badResponse =>
        'Server error: ${err.response?.statusCode}',
      _ => err.message ?? 'An unexpected error occurred.',
    };

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        error: err.error,
        response: err.response,
        type: err.type,
        message: message,
      ),
    );
  }
}
