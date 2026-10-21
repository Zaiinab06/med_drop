import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:med_drop/core/error/exceptions.dart';
import 'package:med_drop/features/orders/data/models/order_model.dart';

/// Contract for persisting and retrieving orders locally on device.
abstract interface class OrderLocalDataSource {
  Future<List<OrderModel>> getCachedOrders();
  Future<void> cacheOrder(OrderModel order);
  Future<void> cacheOrders(List<OrderModel> orders);
}

/// Concrete local data source storing orders in JSON cache file.
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  static const String _fileName = 'orders_cache.json';

  const OrderLocalDataSourceImpl();

  Future<File> _getCacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!file.existsSync()) {
      await file.writeAsString('[]', flush: true);
    }
    return file;
  }

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    try {
      final file = await _getCacheFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) return const [];

      final dynamic decoded = jsonDecode(content);
      if (decoded is! List) return const [];

      final list = decoded
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);

      return list..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      throw CacheException(message: 'Failed to read cached orders: $e');
    }
  }

  @override
  Future<void> cacheOrder(OrderModel order) async {
    try {
      final existing = await getCachedOrders();
      final updated = <OrderModel>[
        order,
        ...existing.where((o) => o.id != order.id),
      ];

      final file = await _getCacheFile();
      final encoded = jsonEncode(updated.map((o) => o.toJson()).toList());
      await file.writeAsString(encoded, flush: true);
    } catch (e) {
      throw CacheException(message: 'Failed to cache order: $e');
    }
  }

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    try {
      final existing = await getCachedOrders();
      final map = {for (final o in existing) o.id: o};
      for (final o in orders) {
        map[o.id] = o;
      }

      final merged = map.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final file = await _getCacheFile();
      final encoded = jsonEncode(merged.map((o) => o.toJson()).toList());
      await file.writeAsString(encoded, flush: true);
    } catch (e) {
      throw CacheException(message: 'Failed to cache orders list: $e');
    }
  }
}
