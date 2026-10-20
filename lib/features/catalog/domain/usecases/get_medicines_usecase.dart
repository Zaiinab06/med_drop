import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';
import 'package:med_drop/features/catalog/domain/repositories/medicine_repository.dart';

/// Fetches the full medicine catalog — optionally bypassing the cache.
///
/// Usage:
/// ```dart
/// final result = await getMedicines(GetMedicinesParams());
/// final freshResult = await getMedicines(GetMedicinesParams(forceRefresh: true));
/// ```
class GetMedicinesUseCase
    implements UseCase<List<MedicineEntity>, GetMedicinesParams> {
  final MedicineRepository _repository;

  const GetMedicinesUseCase(this._repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(
    GetMedicinesParams params,
  ) =>
      _repository.getMedicines(forceRefresh: params.forceRefresh);
}

/// Input parameters for [GetMedicinesUseCase].
final class GetMedicinesParams extends Equatable {
  /// When `true`, the use-case forces a remote fetch and cache refresh.
  final bool forceRefresh;

  const GetMedicinesParams({this.forceRefresh = false});

  @override
  List<Object> get props => [forceRefresh];
}
