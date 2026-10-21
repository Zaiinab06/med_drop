import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:med_drop/features/orders/domain/usecases/place_order_usecase.dart';
import 'package:med_drop/features/orders/presentation/bloc/order/order_event.dart';
import 'package:med_drop/features/orders/presentation/bloc/order/order_state.dart';

/// Coordinates order placement, checkout validation, and order history fetching.
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrderUseCase placeOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;

  OrderBloc({
    required this.placeOrderUseCase,
    required this.getOrdersUseCase,
  }) : super(const OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<FetchOrderHistoryEvent>(_onFetchOrderHistory);
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderPlacing());

    final result = await placeOrderUseCase(
      PlaceOrderParams(
        items: event.items,
        deliveryAddress: event.deliveryAddress,
        prescriptionId: event.prescriptionId,
      ),
    );

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderSuccess(order)),
    );
  }

  Future<void> _onFetchOrderHistory(
    FetchOrderHistoryEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    final result = await getOrdersUseCase(const NoParams());

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrderHistoryLoaded(orders)),
    );
  }
}
