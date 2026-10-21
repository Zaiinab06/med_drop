import 'package:equatable/equatable.dart';

import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';

/// Fulfillment and delivery lifecycle status for an order.
enum OrderStatus {
  pending,
  confirmed,
  outForDelivery,
  delivered,
  cancelled,
}

/// Pure domain entity representing a placed pharmaceutical delivery order.
class OrderEntity extends Equatable {
  /// Unique order identifier (e.g. "ORD-123456").
  final String id;

  /// Ordered medicine items and their quantities.
  final List<CartItemEntity> items;

  /// Total monetary cost in PKR.
  final double totalAmount;

  /// Current order fulfillment status.
  final OrderStatus status;

  /// Street address or delivery location destination.
  final String deliveryAddress;

  /// Linked prescription reference ID if prescription medicines are included.
  final String? prescriptionId;

  /// Creation timestamp.
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    this.prescriptionId,
    required this.createdAt,
  });

  /// Whether any medicine in this order requires a verified prescription.
  bool get requiresPrescription =>
      items.any((item) => item.medicine.requiresPrescription);

  /// Total count of medicine units across all lines.
  int get totalItemUnits => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [
        id,
        items,
        totalAmount,
        status,
        deliveryAddress,
        prescriptionId,
        createdAt,
      ];
}
