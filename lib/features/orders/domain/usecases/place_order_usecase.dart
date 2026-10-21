import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';
import 'package:med_drop/features/orders/domain/entities/order_entity.dart';
import 'package:med_drop/features/orders/domain/repositories/order_repository.dart';

/// Validates checkout parameters and submits a new medicine order.
class PlaceOrderUseCase implements UseCase<OrderEntity, PlaceOrderParams> {
  final OrderRepository repository;

  const PlaceOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(PlaceOrderParams params) async {
    if (params.items.isEmpty) {
      return const Left(
        ValidationFailure('Cannot place an order with an empty cart.'),
      );
    }

    final trimmedAddress = params.deliveryAddress.trim();
    if (trimmedAddress.isEmpty) {
      return const Left(
        ValidationFailure('Delivery address is required.'),
      );
    }

    // Prescription validation: If any medicine requires a doctor's prescription,
    // a valid prescription reference must be attached.
    final hasRxDrugs =
        params.items.any((item) => item.medicine.requiresPrescription);
    final hasValidRxId =
        params.prescriptionId != null && params.prescriptionId!.trim().isNotEmpty;

    if (hasRxDrugs && !hasValidRxId) {
      return const Left(
        ValidationFailure(
          'Your cart contains prescription medicines. Please attach or upload a verified prescription before placing the order.',
        ),
      );
    }

    return repository.placeOrder(
      items: params.items,
      deliveryAddress: trimmedAddress,
      prescriptionId: params.prescriptionId?.trim(),
    );
  }
}

/// Parameters for [PlaceOrderUseCase].
final class PlaceOrderParams extends Equatable {
  final List<CartItemEntity> items;
  final String deliveryAddress;
  final String? prescriptionId;

  const PlaceOrderParams({
    required this.items,
    required this.deliveryAddress,
    this.prescriptionId,
  });

  @override
  List<Object?> get props => [items, deliveryAddress, prescriptionId];
}
