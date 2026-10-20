import 'package:med_drop/features/catalog/data/models/cached_medicine.dart';
import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';

/// Data-layer representation of a medicine — handles serialisation between
/// the remote JSON (Supabase) and the domain [MedicineEntity].
///
/// Extends [MedicineEntity] so it can be used directly where an entity is
/// expected without a separate mapping step in most callers.
class MedicineModel extends MedicineEntity {
  const MedicineModel({
    required super.id,
    required super.brandName,
    required super.saltName,
    required super.dosageForm,
    required super.strength,
    required super.unitPrice,
    required super.stockCount,
    required super.requiresPrescription,
    super.imageUrl,
  });

  // ── Remote JSON ───────────────────────────────────────────────────────────

  /// Deserialises a Supabase/REST JSON map into a [MedicineModel].
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] as String,
      brandName: json['brand_name'] as String,
      saltName: json['salt_name'] as String,
      dosageForm: json['dosage_form'] as String,
      strength: json['strength'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      stockCount: json['stock_count'] as int,
      requiresPrescription: json['requires_prescription'] as bool,
      imageUrl: json['image_url'] as String?,
    );
  }

  /// Serialises this model to a JSON map for remote write operations.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_name': brandName,
      'salt_name': saltName,
      'dosage_form': dosageForm,
      'strength': strength,
      'unit_price': unitPrice,
      'stock_count': stockCount,
      'requires_prescription': requiresPrescription,
      'image_url': imageUrl,
    };
  }

  // ── Domain conversion ─────────────────────────────────────────────────────

  /// Promotes this model up to a pure domain [MedicineEntity].
  ///
  /// Since [MedicineModel] extends [MedicineEntity], `this` already satisfies
  /// the entity contract — this method makes the intent explicit at call sites.
  MedicineEntity toEntity() => this;

  // ── Local cache conversion ────────────────────────────────────────────────

  /// Maps this model onto a [CachedMedicine] Isar object for local storage.
  ///
  /// [lastUpdated] defaults to [DateTime.now()] so callers don't have to
  /// manage the timestamp unless they need a specific value.
  CachedMedicine toCachedMedicine({DateTime? lastUpdated}) {
    return CachedMedicine()
      ..remoteId = id
      ..brandName = brandName
      ..saltName = saltName
      ..dosageForm = dosageForm
      ..strength = strength
      ..unitPrice = unitPrice
      ..stockCount = stockCount
      ..requiresPrescription = requiresPrescription
      ..imageUrl = imageUrl
      ..lastUpdated = lastUpdated ?? DateTime.now();
  }

  /// Reconstructs a [MedicineModel] from a locally cached [CachedMedicine]
  /// object, so that cached data can be surfaced through the domain layer.
  factory MedicineModel.fromCachedMedicine(CachedMedicine cached) {
    return MedicineModel(
      id: cached.remoteId,
      brandName: cached.brandName,
      saltName: cached.saltName,
      dosageForm: cached.dosageForm,
      strength: cached.strength,
      unitPrice: cached.unitPrice,
      stockCount: cached.stockCount,
      requiresPrescription: cached.requiresPrescription,
      imageUrl: cached.imageUrl,
    );
  }
}
