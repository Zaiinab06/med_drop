import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_event.dart';
import 'package:med_drop/features/orders/presentation/bloc/cart/cart_state.dart';

/// Manages client-side cart inventory, quantity adjustments, and Rx compliance checks.
class CartBloc extends Bloc<CartEvent, CartLoaded> {
  CartBloc() : super(CartLoaded.initial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartLoaded> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index =
        currentItems.indexWhere((i) => i.medicine.id == event.medicine.id);

    if (index >= 0) {
      final existing = currentItems[index];
      var newQty = existing.quantity + event.quantity;
      if (newQty > event.medicine.stockCount) {
        newQty = event.medicine.stockCount;
      }
      currentItems[index] = existing.copyWith(quantity: newQty);
    } else {
      var qty = event.quantity;
      if (qty > event.medicine.stockCount) {
        qty = event.medicine.stockCount;
      }
      if (qty > 0) {
        currentItems.add(
          CartItemEntity(medicine: event.medicine, quantity: qty),
        );
      }
    }

    emit(_buildCartLoaded(currentItems));
  }

  void _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartLoaded> emit,
  ) {
    final updated =
        state.items.where((i) => i.medicine.id != event.medicineId).toList();
    emit(_buildCartLoaded(updated));
  }

  void _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartLoaded> emit,
  ) {
    if (event.quantity <= 0) {
      add(RemoveFromCartEvent(event.medicineId));
      return;
    }

    final currentItems = List<CartItemEntity>.from(state.items);
    final index =
        currentItems.indexWhere((i) => i.medicine.id == event.medicineId);

    if (index >= 0) {
      final existing = currentItems[index];
      var qty = event.quantity;
      if (qty > existing.medicine.stockCount) {
        qty = existing.medicine.stockCount;
      }
      currentItems[index] = existing.copyWith(quantity: qty);
      emit(_buildCartLoaded(currentItems));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartLoaded> emit) {
    emit(CartLoaded.initial());
  }

  CartLoaded _buildCartLoaded(List<CartItemEntity> items) {
    final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final hasRx = items.any((item) => item.medicine.requiresPrescription);

    return CartLoaded(
      items: items,
      totalAmount: total,
      containsPrescriptionDrugs: hasRx,
    );
  }
}
