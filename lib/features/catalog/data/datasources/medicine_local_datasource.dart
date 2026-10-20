import 'package:isar/isar.dart';

import 'package:med_drop/core/error/exceptions.dart';
import 'package:med_drop/core/storage/isar_service.dart';
import 'package:med_drop/features/catalog/data/models/cached_medicine.dart';
import 'package:med_drop/features/catalog/data/models/medicine_model.dart';

// ── Contract ──────────────────────────────────────────────────────────────────

/// Defines all local-cache operations for the medicine catalog.
abstract interface class MedicineLocalDataSource {
  /// Returns all medicines currently persisted in the local Isar cache.
  ///
  /// Throws [CacheException] if the read fails.
  Future<List<MedicineModel>> getCachedMedicines();

  /// Returns medicines whose brand name or salt name contains [query]
  /// (case-insensitive). Searches the local Isar cache only.
  ///
  /// Throws [CacheException] if the read fails.
  Future<List<MedicineModel>> searchCachedMedicines(String query);

  /// Upserts [medicines] into the local Isar cache inside a single
  /// write transaction. Existing records matched by `remoteId` are replaced.
  ///
  /// Throws [CacheException] if the write fails.
  Future<void> cacheMedicines(List<MedicineModel> medicines);
}

// ── Implementation ────────────────────────────────────────────────────────────

/// Concrete local data source backed by [IsarService].
class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final IsarService _isarService;

  const MedicineLocalDataSourceImpl(this._isarService);

  /// Convenience accessor for the opened [Isar] instance.
  Isar get _db => _isarService.db;

  @override
  Future<List<MedicineModel>> getCachedMedicines() async {
    try {
      final cached = await _db.cachedMedicines.where().findAll();
      return cached
          .map(MedicineModel.fromCachedMedicine)
          .toList(growable: false);
    } on IsarError catch (e) {
      throw CacheException(message: 'Failed to read medicines cache: $e');
    } catch (e) {
      throw CacheException(message: 'Failed to read medicines cache: $e');
    }
  }

  @override
  Future<List<MedicineModel>> searchCachedMedicines(String query) async {
    try {
      final results = await _db.cachedMedicines
          .filter()
          .brandNameContains(query, caseSensitive: false)
          .or()
          .saltNameContains(query, caseSensitive: false)
          .findAll();

      return results
          .map(MedicineModel.fromCachedMedicine)
          .toList(growable: false);
    } on IsarError catch (e) {
      throw CacheException(message: 'Failed to search medicines cache: $e');
    } catch (e) {
      throw CacheException(message: 'Failed to search medicines cache: $e');
    }
  }

  @override
  Future<void> cacheMedicines(List<MedicineModel> medicines) async {
    try {
      final now = DateTime.now();
      final objects = medicines
          .map((m) => m.toCachedMedicine(lastUpdated: now))
          .toList(growable: false);

      // `putAll` respects the `@Index(unique: true, replace: true)` on
      // `remoteId`, so this is effectively an upsert.
      await _db.writeTxn(() => _db.cachedMedicines.putAll(objects));
    } on IsarError catch (e) {
      throw CacheException(message: 'Failed to write medicines cache: $e');
    } catch (e) {
      throw CacheException(message: 'Failed to write medicines cache: $e');
    }
  }
}
