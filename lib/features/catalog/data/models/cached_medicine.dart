import 'package:isar/isar.dart';

// ⚠️  Run `dart run build_runner build --delete-conflicting-outputs`
// after any change to this file to regenerate `cached_medicine.g.dart`.
part 'cached_medicine.g.dart';

/// Isar collection that caches medicine data locally on the device.
///
/// The [remoteId] field is the canonical Supabase UUID for the row and is
/// marked unique — inserting a duplicate [remoteId] replaces the existing
/// record (upsert behaviour via `replace: true`).
@collection
class CachedMedicine {
  // ── Isar identity ─────────────────────────────────────────────────────────

  /// Auto-incremented local integer primary key (Isar requirement).
  Id id = Isar.autoIncrement;

  // ── Remote identity ───────────────────────────────────────────────────────

  /// Supabase UUID — unique across all cached rows; enables upsert.
  @Index(unique: true, replace: true)
  late String remoteId;

  // ── Searchable fields ─────────────────────────────────────────────────────

  /// Brand name — case-insensitive index enables fast prefix / contains search.
  @Index(type: IndexType.value, caseSensitive: false)
  late String brandName;

  /// Salt / INN name — same index strategy as [brandName].
  @Index(type: IndexType.value, caseSensitive: false)
  late String saltName;

  // ── Other fields ──────────────────────────────────────────────────────────

  late String dosageForm;
  late String strength;
  late double unitPrice;
  late int stockCount;
  late bool requiresPrescription;

  /// Optional product image URL. May be `null` for items without images.
  String? imageUrl;

  /// Timestamp of the last successful sync with the remote source.
  /// Used by the repository to determine cache freshness.
  late DateTime lastUpdated;
}
