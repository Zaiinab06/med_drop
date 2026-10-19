import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/isar_service.dart';

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
  // Feature-level registrations will be added here as features are built.
  // e.g. _initCatalog();
}

// ── Feature init helpers (template) ─────────────────────────────────────────

// void _initCatalog() {
//   // Data sources
//   sl.registerLazySingleton<CatalogRemoteDataSource>(
//     () => CatalogRemoteDataSourceImpl(sl<DioClient>().dio),
//   );
//   // Repository
//   sl.registerLazySingleton<CatalogRepository>(
//     () => CatalogRepositoryImpl(
//       remoteDataSource: sl(),
//       networkInfo: sl(),
//     ),
//   );
//   // Use cases
//   sl.registerLazySingleton(() => GetMedicines(sl()));
//   // BLoC — factory so each screen gets a fresh instance
//   sl.registerFactory(() => CatalogBloc(getMedicines: sl()));
// }
