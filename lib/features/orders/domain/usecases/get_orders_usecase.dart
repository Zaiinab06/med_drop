import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/usecase/usecase.dart';
import 'package:med_drop/features/orders/domain/entities/order_entity.dart';
import 'package:med_drop/features/orders/domain/repositories/order_repository.dart';

/// Fetches historical orders placed by the user.
class GetOrdersUseCase implements UseCase<List<OrderEntity>, NoParams> {
  final OrderRepository repository;

  const GetOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repository.getOrderHistory();
  }
}
