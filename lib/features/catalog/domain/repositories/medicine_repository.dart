import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';

/// Contract for fetching medicine catalog data.
///
/// The concrete implementation lives in the *data* layer and is swapped in
/// via the DI container — the domain layer is never aware of the source.
abstract interface class MedicineRepository {
  /// Returns the full medicine catalog.
  ///
  /// - [forceRefresh] — when `true`, bypasses the local cache and fetches
  ///   fresh data from the remote source, then re-populates the cache.
  /// - When `false` (default), returns cached data if available and fresh,
  ///   falling back to remote only when the cache is stale or empty.
  Future<Either<Failure, List<MedicineEntity>>> getMedicines({
    bool forceRefresh = false,
  });

  /// Returns medicines whose [MedicineEntity.brandName] or
  /// [MedicineEntity.saltName] contains [query] (case-insensitive).
  ///
  /// Search is performed locally against the Isar cache for instant results.
  Future<Either<Failure, List<MedicineEntity>>> searchMedicines(String query);
}
