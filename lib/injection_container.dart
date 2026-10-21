import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/isar_service.dart';
import 'features/catalog/data/datasources/medicine_local_datasource.dart';
import 'features/catalog/data/datasources/medicine_remote_datasource.dart';
import 'features/catalog/data/repositories/medicine_repository_impl.dart';
import 'features/catalog/domain/repositories/medicine_repository.dart';
import 'features/catalog/domain/usecases/get_medicines_usecase.dart';
import 'features/catalog/domain/usecases/search_medicines_usecase.dart';
import 'features/catalog/presentation/bloc/catalog_bloc.dart';
import 'features/orders/data/datasources/order_local_datasource.dart';
import 'features/orders/data/datasources/order_remote_datasource.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/domain/usecases/get_orders_usecase.dart';
import 'features/orders/domain/usecases/place_order_usecase.dart';
import 'features/orders/presentation/bloc/cart/cart_bloc.dart';
import 'features/orders/presentation/bloc/order/order_bloc.dart';
import 'features/prescription/data/datasources/prescription_local_datasource.dart';
import 'features/prescription/data/datasources/prescription_remote_datasource.dart';
import 'features/prescription/data/repositories/prescription_repository_impl.dart';
import 'features/prescription/data/services/image_compression_service.dart';
import 'features/prescription/domain/repositories/prescription_repository.dart';
import 'features/prescription/domain/usecases/get_prescriptions_usecase.dart';
import 'features/prescription/domain/usecases/upload_prescription_usecase.dart';
import 'features/prescription/presentation/bloc/prescription_bloc.dart';

/// Global [GetIt] service locator instance.
///
/// Access registered dependencies anywhere via `sl<T>()`.
final GetIt sl = GetIt.instance;

/// Registers all application dependencies with the [GetIt] service locator.
///
/// Call this once inside [main], before [runApp], after
/// [WidgetsFlutterBinding.ensureInitialized].
///
/// Registration order matters when one dependency depends on another —
/// always register lower-level services first.
Future<void> init() async {
  // ── External / Third-party ─────────────────────────────────────────────

  // connectivity_plus — singleton so the same stream is reused app-wide
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<ImagePicker>(() => ImagePicker());

  // ── Core: Storage ─────────────────────────────────────────────────────

  // IsarService must be awaited before the app renders so DB is ready
  final isarService = IsarService();
  await isarService.init();
  sl.registerSingleton<IsarService>(isarService);

  // ── Core: Network ─────────────────────────────────────────────────────

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ── Features ──────────────────────────────────────────────────────────
  _initCatalog();
  _initPrescription();
  _initOrders();
}

// ── Feature init helpers ─────────────────────────────────────────────────────

void _initCatalog() {
  // Data sources
  sl.registerLazySingleton<MedicineLocalDataSource>(
    () => MedicineLocalDataSourceImpl(sl<IsarService>()),
  );
  sl.registerLazySingleton<MedicineRemoteDataSource>(
    () => MedicineRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<MedicineRepository>(
    () => MedicineRepositoryImpl(
      remote: sl<MedicineRemoteDataSource>(),
      local: sl<MedicineLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetMedicinesUseCase>(
    () => GetMedicinesUseCase(sl<MedicineRepository>()),
  );
  sl.registerLazySingleton<SearchMedicinesUseCase>(
    () => SearchMedicinesUseCase(sl<MedicineRepository>()),
  );

  // BLoC
  sl.registerFactory<CatalogBloc>(
    () => CatalogBloc(
      getMedicinesUseCase: sl<GetMedicinesUseCase>(),
      searchMedicinesUseCase: sl<SearchMedicinesUseCase>(),
    ),
  );
}

void _initPrescription() {
  // Services
  sl.registerLazySingleton<ImageCompressionService>(
    () => const ImageCompressionService(),
  );

  // Data sources
  sl.registerLazySingleton<PrescriptionLocalDataSource>(
    () => const PrescriptionLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<PrescriptionRemoteDataSource>(
    () => const PrescriptionRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<PrescriptionRepository>(
    () => PrescriptionRepositoryImpl(
      remoteDataSource: sl<PrescriptionRemoteDataSource>(),
      localDataSource: sl<PrescriptionLocalDataSource>(),
      imageCompressionService: sl<ImageCompressionService>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<UploadPrescriptionUseCase>(
    () => UploadPrescriptionUseCase(sl<PrescriptionRepository>()),
  );
  sl.registerLazySingleton<GetPrescriptionsUseCase>(
    () => GetPrescriptionsUseCase(sl<PrescriptionRepository>()),
  );

  // BLoC
  sl.registerFactory<PrescriptionBloc>(
    () => PrescriptionBloc(
      uploadPrescriptionUseCase: sl<UploadPrescriptionUseCase>(),
      getPrescriptionsUseCase: sl<GetPrescriptionsUseCase>(),
      imagePicker: sl<ImagePicker>(),
    ),
  );
}

void _initOrders() {
  // Data sources
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => const OrderLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => const OrderRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: sl<OrderRemoteDataSource>(),
      localDataSource: sl<OrderLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(sl<OrderRepository>()),
  );
  sl.registerLazySingleton<GetOrdersUseCase>(
    () => GetOrdersUseCase(sl<OrderRepository>()),
  );

  // BLoC — CartBloc is a singleton so cart state persists across navigation
  sl.registerLazySingleton<CartBloc>(() => CartBloc());

  // OrderBloc
  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      placeOrderUseCase: sl<PlaceOrderUseCase>(),
      getOrdersUseCase: sl<GetOrdersUseCase>(),
    ),
  );
}
