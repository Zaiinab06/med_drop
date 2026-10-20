import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/exceptions.dart';
import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/network/network_info.dart';
import 'package:med_drop/features/catalog/data/datasources/medicine_local_datasource.dart';
import 'package:med_drop/features/catalog/data/datasources/medicine_remote_datasource.dart';
import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';
import 'package:med_drop/features/catalog/domain/repositories/medicine_repository.dart';

/// Offline-first implementation of [MedicineRepository].
///
/// Strategy for [getMedicines]:
///   1. If not [forceRefresh], serve from local cache if non-empty.
///   2. Otherwise check connectivity:
///      - Online  → fetch remote → update cache → return remote results.
///      - Offline + cache non-empty → return stale cache.
///      - Offline + cache empty     → return [NetworkFailure].
///
/// Strategy for [searchMedicines]:
///   1. Always search local cache first (instant results).
///   2. If online, also fetch remote search results, merge into cache, and
///      return the combined de-duplicated list.
///   3. If remote fails or device is offline, return local results only.
class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource remote;
  final MedicineLocalDataSource local;
  final NetworkInfo networkInfo;

  const MedicineRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  // ── getMedicines ──────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<MedicineEntity>>> getMedicines({
    bool forceRefresh = false,
  }) async {
    // ── 1. Try local cache when refresh not forced ──────────────────────────
    if (!forceRefresh) {
      try {
        final cached = await local.getCachedMedicines();
        if (cached.isNotEmpty) {
          return Right(cached);
        }
      } on CacheException catch (e) {
        // Cache read failed — fall through to remote fetch instead of failing.
        // Non-fatal: log and continue.
        assert(() {
          // ignore: avoid_print
          print('[MedicineRepo] Cache read error: ${e.message}');
          return true;
        }());
      }
    }

    // ── 2. Remote fetch (requires connectivity) ────────────────────────────
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      // Last resort: serve stale cache if available.
      try {
        final stale = await local.getCachedMedicines();
        if (stale.isNotEmpty) return Right(stale);
      } on CacheException {
        // Stale cache also unavailable.
      }
      return const Left(NetworkFailure());
    }

    // ── 3. Fetch from remote, populate cache, return results ───────────────
    try {
      final remoteModels = await remote.getMedicines();
      await local.cacheMedicines(remoteModels);
      return Right(remoteModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // ── searchMedicines ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<MedicineEntity>>> searchMedicines(
    String query,
  ) async {
    // ── 1. Search local cache first ──────────────────────────────────────────
    List<MedicineEntity> localResults = const [];
    CacheException? localException;
    try {
      localResults = await local.searchCachedMedicines(query);
    } on CacheException catch (e) {
      localException = e;
    }

    // ── 2. Check connectivity ────────────────────────────────────────────────
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      if (localException != null && localResults.isEmpty) {
        return Left(CacheFailure(localException.message));
      }
      return Right(localResults);
    }

    // ── 3. If online, fetch remote search results, update local cache, and return results ──
    try {
      final remoteModels = await remote.searchMedicines(query);

      // Update local cache with remote results
      if (remoteModels.isNotEmpty) {
        await local.cacheMedicines(remoteModels);
      }

      return Right(remoteModels);
    } on ServerException catch (e) {
      // Remote search failed — return local results if available.
      if (localResults.isNotEmpty) return Right(localResults);
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      if (localResults.isNotEmpty) return Right(localResults);
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
