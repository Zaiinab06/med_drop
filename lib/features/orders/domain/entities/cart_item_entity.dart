import 'package:equatable/equatable.dart';

import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';

/// Pure domain entity representing an item inside the user's shopping cart.
class CartItemEntity extends Equatable {
  /// The medicine added to the cart.
  final MedicineEntity medicine;

  /// Number of units selected by the user.
  final int quantity;

  const CartItemEntity({
    required this.medicine,
    required this.quantity,
  });

  /// Total calculated price for this specific cart item in PKR.
  double get totalPrice => medicine.unitPrice * quantity;

  CartItemEntity copyWith({
    MedicineEntity? medicine,
    int? quantity,
  }) {
    return CartItemEntity(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [medicine, quantity];
}
