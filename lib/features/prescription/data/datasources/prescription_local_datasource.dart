import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:med_drop/core/error/exceptions.dart';
import 'package:med_drop/features/prescription/data/models/prescription_model.dart';

/// Contract for persisting and retrieving prescription metadata locally on the device.
abstract interface class PrescriptionLocalDataSource {
  /// Returns all previously cached prescriptions, sorted by newest first.
  ///
  /// Throws [CacheException] on read failure.
  Future<List<PrescriptionModel>> getCachedPrescriptions();

  /// Upserts a single [prescription] record into local storage.
  ///
  /// Throws [CacheException] on write failure.
  Future<void> cachePrescription(PrescriptionModel prescription);

  /// Overwrites or merges a list of [prescriptions] into local storage.
  ///
  /// Throws [CacheException] on write failure.
  Future<void> cachePrescriptions(List<PrescriptionModel> prescriptions);
}

/// Concrete local data source backed by structured JSON file storage.
///
/// Ensures offline persistence without requiring schema code-generation cycles.
class PrescriptionLocalDataSourceImpl implements PrescriptionLocalDataSource {
  static const String _fileName = 'prescriptions_cache.json';

  const PrescriptionLocalDataSourceImpl();

  Future<File> _getCacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!file.existsSync()) {
      await file.writeAsString('[]', flush: true);
    }
    return file;
  }

  @override
  Future<List<PrescriptionModel>> getCachedPrescriptions() async {
    try {
      final file = await _getCacheFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) return const [];

      final dynamic decoded = jsonDecode(content);
      if (decoded is! List) return const [];

      final list = decoded
          .map((item) => PrescriptionModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);

      // Sort newest first
      return list..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    } catch (e) {
      throw CacheException(
        message: 'Failed to read cached prescriptions: $e',
      );
    }
  }

  @override
  Future<void> cachePrescription(PrescriptionModel prescription) async {
    try {
      final existing = await getCachedPrescriptions();
      final updated = <PrescriptionModel>[
        prescription,
        ...existing.where((p) => p.id != prescription.id),
      ];

      final file = await _getCacheFile();
      final encoded = jsonEncode(updated.map((p) => p.toJson()).toList());
      await file.writeAsString(encoded, flush: true);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache prescription: $e',
      );
    }
  }

  @override
  Future<void> cachePrescriptions(List<PrescriptionModel> prescriptions) async {
    try {
      final existing = await getCachedPrescriptions();
      final map = {for (final p in existing) p.id: p};
      for (final p in prescriptions) {
        map[p.id] = p;
      }

      final merged = map.values.toList()
        ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      final file = await _getCacheFile();
      final encoded = jsonEncode(merged.map((p) => p.toJson()).toList());
      await file.writeAsString(encoded, flush: true);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache prescriptions list: $e',
      );
    }
  }
}
