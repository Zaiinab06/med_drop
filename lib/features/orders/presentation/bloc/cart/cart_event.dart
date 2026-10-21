import 'package:equatable/equatable.dart';

import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';

/// Base class for all cart manipulation events.
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched when a patient adds a medicine to their cart.
final class AddToCartEvent extends CartEvent {
  final MedicineEntity medicine;
  final int quantity;

  const AddToCartEvent(this.medicine, {this.quantity = 1});

  @override
  List<Object?> get props => [medicine, quantity];
}

/// Dispatched when removing a medicine entirely from the cart.
final class RemoveFromCartEvent extends CartEvent {
  final String medicineId;

  const RemoveFromCartEvent(this.medicineId);

  @override
  List<Object?> get props => [medicineId];
}

/// Dispatched when incrementing, decrementing, or setting a specific item quantity.
final class UpdateQuantityEvent extends CartEvent {
  final String medicineId;
  final int quantity;

  const UpdateQuantityEvent(this.medicineId, this.quantity);

  @override
  List<Object?> get props => [medicineId, quantity];
}

/// Dispatched to empty the entire cart.
final class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
