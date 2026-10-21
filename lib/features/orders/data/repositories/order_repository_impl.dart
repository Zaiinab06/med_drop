import 'package:fpdart/fpdart.dart';

import 'package:med_drop/core/error/exceptions.dart';
import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/core/network/network_info.dart';
import 'package:med_drop/features/orders/data/datasources/order_local_datasource.dart';
import 'package:med_drop/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:med_drop/features/orders/domain/entities/cart_item_entity.dart';
import 'package:med_drop/features/orders/domain/entities/order_entity.dart';
import 'package:med_drop/features/orders/domain/repositories/order_repository.dart';

/// Concrete implementation of [OrderRepository] coordinating remote submissions
/// and local cache persistence.
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required List<CartItemEntity> items,
    required String deliveryAddress,
    String? prescriptionId,
  }) async {
    try {
      final order = await remoteDataSource.placeOrder(
        items: items,
        deliveryAddress: deliveryAddress,
        prescriptionId: prescriptionId,
      );

      // Persist in local storage so order history is accessible offline
      try {
        await localDataSource.cacheOrder(order);
      } on CacheException {
        // Non-fatal: order is confirmed even if local cache write encounters an issue
      }

      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to place order: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory() async {
    List<OrderEntity> localOrders = const [];
    try {
      localOrders = await localDataSource.getCachedOrders();
    } on CacheException {
      // Fall through to remote
    }

    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      return Right(localOrders);
    }

    try {
      final remoteOrders = await remoteDataSource.getRemoteOrders();

      if (remoteOrders.isNotEmpty) {
        await localDataSource.cacheOrders(remoteOrders);
      }

      final remoteIds = remoteOrders.map((o) => o.id).toSet();
      final localOnly =
          localOrders.where((o) => !remoteIds.contains(o.id)).toList();

      final combined = [...remoteOrders, ...localOnly]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(combined.isNotEmpty ? combined : localOrders);
    } on ServerException catch (e) {
      if (localOrders.isNotEmpty) return Right(localOrders);
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      if (localOrders.isNotEmpty) return Right(localOrders);
      return Left(ServerFailure('Failed to retrieve order history: $e'));
    }
  }
}
