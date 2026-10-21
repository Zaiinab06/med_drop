import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/exceptions.dart';
import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/network/network_info.dart';
import 'package:med_drop/features/prescription/data/datasources/prescription_local_datasource.dart';
import 'package:med_drop/features/prescription/data/datasources/prescription_remote_datasource.dart';
import 'package:med_drop/features/prescription/data/services/image_compression_service.dart';
import 'package:med_drop/features/prescription/domain/entities/prescription_entity.dart';
import 'package:med_drop/features/prescription/domain/repositories/prescription_repository.dart';

/// Concrete implementation of [PrescriptionRepository] integrating image compression,
/// remote storage, and offline-first local caching.
class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource remoteDataSource;
  final PrescriptionLocalDataSource localDataSource;
  final ImageCompressionService imageCompressionService;
  final NetworkInfo networkInfo;

  const PrescriptionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.imageCompressionService,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PrescriptionEntity>> uploadPrescription({
    required File file,
    String? patientNotes,
  }) async {
    try {
      // 1. Optimize image resolution & compress to strictly below 1MB
      final compressedFile = await imageCompressionService.compressImage(file);

      // 2. Upload to remote endpoint / Supabase storage (with fallback)
      final model = await remoteDataSource.uploadPrescription(
        file: compressedFile,
        patientNotes: patientNotes,
      );

      // 3. Cache uploaded record locally for offline history
      try {
        await localDataSource.cachePrescription(model);
      } on CacheException {
        // Non-fatal: upload succeeded even if local cache write had an issue.
      }

      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to upload prescription: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PrescriptionEntity>>>
      getPrescriptionHistory() async {
    List<PrescriptionEntity> localRecords = const [];
    try {
      localRecords = await localDataSource.getCachedPrescriptions();
    } on CacheException {
      // Proceed to remote if local cache read encounters an issue
    }

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      // Offline mode: serve persisted records
      return Right(localRecords);
    }

    try {
      final remoteRecords = await remoteDataSource.getRemotePrescriptions();

      if (remoteRecords.isNotEmpty) {
        await localDataSource.cachePrescriptions(remoteRecords);
      }

      // Merge: remote takes precedence, local records fill any gaps
      final remoteIds = remoteRecords.map((r) => r.id).toSet();
      final localOnly =
          localRecords.where((r) => !remoteIds.contains(r.id)).toList();

      final combined = [...remoteRecords, ...localOnly]
        ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      return Right(combined.isNotEmpty ? combined : localRecords);
    } on ServerException catch (e) {
      if (localRecords.isNotEmpty) return Right(localRecords);
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      if (localRecords.isNotEmpty) return Right(localRecords);
      return Left(ServerFailure('Failed to load prescription history: $e'));
    }
  }
}
