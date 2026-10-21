import 'package:equatable/equatable.dart';

import 'package:med_drop/features/orders/domain/entities/order_entity.dart';

/// Base class for all order workflow states.
sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Initial state before order placement begins.
final class OrderInitial extends OrderState {
  const OrderInitial();
}

/// State emitted while the order checkout request is in progress.
final class OrderPlacing extends OrderState {
  const OrderPlacing();
}

/// State emitted while fetching order history.
final class OrderLoading extends OrderState {
  const OrderLoading();
}

/// State emitted when the order is successfully placed and confirmed.
final class OrderSuccess extends OrderState {
  final OrderEntity order;

  const OrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

/// State emitted when order history has been fetched.
final class OrderHistoryLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrderHistoryLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

/// State emitted when an error occurs during checkout or history fetch.
final class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
