import 'package:equatable/equatable.dart';

/// Pure domain entity representing a medicine in the catalog.
///
/// This class has **zero** framework or data-layer dependencies.
/// All data-layer objects (models, cached objects) must convert *to* this type
/// before crossing into the domain / presentation layer.
class MedicineEntity extends Equatable {
  /// Supabase row UUID — used as the canonical cross-layer identifier.
  final String id;

  /// Commercial / brand name (e.g. "Panadol").
  final String brandName;

  /// Active ingredient / INN salt name (e.g. "Paracetamol").
  final String saltName;

  /// Dosage form (e.g. "Tablet", "Syrup", "Injection").
  final String dosageForm;

  /// Strength with unit (e.g. "500 mg", "250 mg/5 mL").
  final String strength;

  /// Retail unit price in the local currency.
  final double unitPrice;

  /// Number of units currently available in inventory.
  final int stockCount;

  /// Whether this medicine can only be dispensed with a valid prescription.
  final bool requiresPrescription;

  /// Optional CDN URL for the product image.
  final String? imageUrl;

  const MedicineEntity({
    required this.id,
    required this.brandName,
    required this.saltName,
    required this.dosageForm,
    required this.strength,
    required this.unitPrice,
    required this.stockCount,
    required this.requiresPrescription,
    this.imageUrl,
  });

  // ── Derived helpers ───────────────────────────────────────────────────────

  /// `true` when at least one unit is available.
  bool get isInStock => stockCount > 0;

  /// `true` when no units are available.
  bool get isOutOfStock => stockCount == 0;

  // ── Equatable ─────────────────────────────────────────────────────────────

  @override
  List<Object?> get props => [
        id,
        brandName,
        saltName,
        dosageForm,
        strength,
        unitPrice,
        stockCount,
        requiresPrescription,
        imageUrl,
      ];
}
