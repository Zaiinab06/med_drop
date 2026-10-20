import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';
import 'package:med_drop/features/catalog/domain/repositories/medicine_repository.dart';

/// Searches the local medicine cache by brand name or salt name.
///
/// Usage:
/// ```dart
/// final result = await searchMedicines(SearchMedicinesParams(query: 'para'));
/// ```
class SearchMedicinesUseCase
    implements UseCase<List<MedicineEntity>, SearchMedicinesParams> {
  final MedicineRepository _repository;

  const SearchMedicinesUseCase(this._repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(
    SearchMedicinesParams params,
  ) {
    final trimmed = params.query.trim();

    // Guard: treat a blank query as a validation failure rather than
    // executing a full-table scan that returns everything.
    if (trimmed.isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Search query must not be empty.')),
      );
    }

    return _repository.searchMedicines(trimmed);
  }
}

/// Input parameters for [SearchMedicinesUseCase].
final class SearchMedicinesParams extends Equatable {
  /// The raw search string entered by the user.
  final String query;

  const SearchMedicinesParams({required this.query});

  @override
  List<Object> get props => [query];
}
