import 'package:equatable/equatable.dart';

import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';

/// Base class for cart states.
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// State representing the current cart inventory, calculated price, and Rx drug status.
final class CartLoaded extends CartState {
  /// The list of items currently in the cart.
  final List<CartItemEntity> items;

  /// Total cost of all items in PKR.
  final double totalAmount;

  /// Whether any item currently in the cart requires a verified doctor's prescription.
  final bool containsPrescriptionDrugs;

  const CartLoaded({
    required this.items,
    required this.totalAmount,
    required this.containsPrescriptionDrugs,
  });

  /// Factory creating an empty initial cart state.
  factory CartLoaded.initial() {
    return const CartLoaded(
      items: [],
      totalAmount: 0.0,
      containsPrescriptionDrugs: false,
    );
  }

  /// Total count of physical units in the cart (sum of all item quantities).
  int get totalItemUnits => items.fold(0, (sum, item) => sum + item.quantity);

  /// Whether the cart currently contains zero items.
  bool get isEmpty => items.isEmpty;

  /// Whether the cart contains at least one item.
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [items, totalAmount, containsPrescriptionDrugs];
}
