import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:med_drop/core/constants/app_constants.dart';
import 'package:med_drop/features/catalog/data/models/cached_medicine.dart';

/// Manages the lifecycle of the [Isar] local database instance.
///
/// Call [init] once during app startup (before the widget tree is inflated).
/// Call [close] when the app is shutting down or during integration tests.
///
/// Schema collections are registered here as they are created — add entries
/// to [_schemas] whenever a new Isar model is generated.
class IsarService {
  /// The opened [Isar] instance. Available after [init] resolves.
  late Isar db;

  /// Schemas to open with the database.
  ///
  /// Add generated `XxxSchema` constants here as new Isar collections are
  /// introduced. Schema constants are produced by `build_runner`.
  // ignore: prefer_const_declarations — generated schemas are not compile-time constants.
  static final List<CollectionSchema<dynamic>> _schemas = [
    CachedMedicineSchema,
  ];

  /// Opens the Isar instance and assigns it to [db].
  ///
  /// Safe to call multiple times — re-attaches to an existing named instance
  /// if one is already open instead of creating a duplicate.
  Future<void> init() async {
    // Always resolve the documents directory first — Isar.open requires it
    // even when re-attaching to an already-open named instance.
    final dir = await getApplicationDocumentsDirectory();

    db = await Isar.open(
      _schemas,
      directory: dir.path,
      name: AppConstants.isarDbName,
      // Enable the DevTools inspector only in debug builds.
      inspector: kDebugMode,
    );
  }

  /// Closes the database. Should be called from [WidgetsBindingObserver]
  /// on [AppLifecycleState.detached] or in test teardown.
  Future<void> close() async {
    if (db.isOpen) {
      await db.close();
    }
  }
}
