import 'package:equatable/equatable.dart';

import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';

/// Base class for all order workflow events.
sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched to submit checkout and create a placed order.
final class PlaceOrderEvent extends OrderEvent {
  final List<CartItemEntity> items;
  final String deliveryAddress;
  final String? prescriptionId;

  const PlaceOrderEvent({
    required this.items,
    required this.deliveryAddress,
    this.prescriptionId,
  });

  @override
  List<Object?> get props => [items, deliveryAddress, prescriptionId];
}

/// Dispatched to retrieve past order history.
final class FetchOrderHistoryEvent extends OrderEvent {
  const FetchOrderHistoryEvent();
}
