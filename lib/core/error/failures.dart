import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Emitted when a remote/API call fails.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred.']);
}

/// Emitted when reading from or writing to local storage fails.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A local cache error occurred.']);
}

/// Emitted when there is no active internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection available.']);
}

/// Emitted when input validation fails before a request is made.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Input validation failed.']);
}
