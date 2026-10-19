/// Thrown by remote data sources when an API / server call fails.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'An unexpected server error occurred.',
    this.statusCode,
  });

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, message: $message)';
}

/// Thrown by local data sources when a cache read or write fails.
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'A local cache error occurred.',
  });

  @override
  String toString() => 'CacheException(message: $message)';
}
