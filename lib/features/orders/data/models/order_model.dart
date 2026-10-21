import 'package:med_drop/features/orders/data/models/cart_item_model.dart';
import 'package:med_drop/features/orders/domain/entities/order_entity.dart';

/// Data transfer object serializing [OrderEntity] to and from JSON.
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.deliveryAddress,
    super.prescriptionId,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    final items = rawItems
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    return OrderModel(
      id: json['id'] as String,
      items: items,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: _statusFromString(json['status'] as String?),
      deliveryAddress: json['delivery_address'] as String,
      prescriptionId: json['prescription_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) {
        if (item is CartItemModel) return item.toJson();
        return CartItemModel.fromEntity(item).toJson();
      }).toList(growable: false),
      'total_amount': totalAmount,
      'status': status.name,
      'delivery_address': deliveryAddress,
      'prescription_id': prescriptionId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      items: entity.items,
      totalAmount: entity.totalAmount,
      status: entity.status,
      deliveryAddress: entity.deliveryAddress,
      prescriptionId: entity.prescriptionId,
      createdAt: entity.createdAt,
    );
  }

  static OrderStatus _statusFromString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'confirmed' => OrderStatus.confirmed,
      'outfordelivery' || 'out_for_delivery' => OrderStatus.outForDelivery,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };
  }
}
