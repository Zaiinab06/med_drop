import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/isar_service.dart';
import 'features/catalog/data/datasources/medicine_local_datasource.dart';
import 'features/catalog/data/datasources/medicine_remote_datasource.dart';
import 'features/catalog/data/repositories/medicine_repository_impl.dart';
import 'features/catalog/domain/repositories/medicine_repository.dart';
import 'features/catalog/domain/usecases/get_medicines_usecase.dart';
import 'features/catalog/domain/usecases/search_medicines_usecase.dart';

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
}
