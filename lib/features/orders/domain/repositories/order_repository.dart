import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';
import 'package:med_drop/features/orders/domain/entities/order_entity.dart';

/// Contract defining all order and checkout operations in the domain layer.
abstract interface class OrderRepository {
  /// Places a new medicine delivery order.
  ///
  /// [items] – The cart items to order.
  /// [deliveryAddress] – Destination for medicine drop-off.
  /// [prescriptionId] – Required if any item has `requiresPrescription == true`.
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required String deliveryAddress,
    String? prescriptionId,
  });

  /// Retrieves previous orders placed by the user.
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory();
}
