import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:med_drop/core/error/failures.dart';

/// Contract that every use-case must satisfy.
///
/// [T]      – the successful return value (e.g. `List<Medicine>`).
/// [Params] – the input parameter object (use [NoParams] when none needed).
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Sentinel parameter class for use-cases that take no arguments.
final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
