import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:med_drop/core/constants/app_constants.dart';
import 'package:med_drop/core/error/failures.dart';
import 'package:med_drop/features/catalog/domain/usecases/get_medicines_usecase.dart';
import 'package:med_drop/features/catalog/domain/usecases/search_medicines_usecase.dart';
import 'package:med_drop/features/catalog/presentation/bloc/catalog_event.dart';
import 'package:med_drop/features/catalog/presentation/bloc/catalog_state.dart';

/// Manages state and business logic for the Medicine Catalog screen.
///
/// Injects [GetMedicinesUseCase] for full-catalog fetches and
/// [SearchMedicinesUseCase] for filtered searches.
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final GetMedicinesUseCase getMedicinesUseCase;
  final SearchMedicinesUseCase searchMedicinesUseCase;

  CatalogBloc({
    required this.getMedicinesUseCase,
    required this.searchMedicinesUseCase,
  }) : super(const CatalogInitial()) {
    on<LoadCatalogEvent>(_onLoadCatalog);
    on<SearchCatalogEvent>(
      _onSearchCatalog,
      transformer: _debounce(AppConstants.searchDebounce),
    );
    on<ClearSearchEvent>(_onClearSearch);
  }

  // ── Event Handlers ────────────────────────────────────────────────────────

  Future<void> _onLoadCatalog(
    LoadCatalogEvent event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoading());

    final result = await getMedicinesUseCase(
      GetMedicinesParams(forceRefresh: event.forceRefresh),
    );

    result.fold(
      (failure) => emit(CatalogError(_mapFailureToMessage(failure))),
      (medicines) {
        if (medicines.isEmpty) {
          emit(const CatalogEmpty('No medicines available in the catalog.'));
        } else {
          emit(CatalogLoaded(medicines));
        }
      },
    );
  }

  Future<void> _onSearchCatalog(
    SearchCatalogEvent event,
    Emitter<CatalogState> emit,
  ) async {
    final trimmed = event.query.trim();

    // If query was cleared or empty, revert to the full catalog.
    if (trimmed.isEmpty) {
      add(const ClearSearchEvent());
      return;
    }

    emit(const CatalogLoading());

    final result = await searchMedicinesUseCase(
      SearchMedicinesParams(query: trimmed),
    );

    result.fold(
      (failure) => emit(CatalogError(_mapFailureToMessage(failure))),
      (results) {
        if (results.isEmpty) {
          emit(CatalogEmpty('No medicines found matching "$trimmed".'));
        } else {
          emit(CatalogLoaded(results, isSearching: true, query: trimmed));
        }
      },
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoading());

    final result = await getMedicinesUseCase(
      const GetMedicinesParams(forceRefresh: false),
    );

    result.fold(
      (failure) => emit(CatalogError(_mapFailureToMessage(failure))),
      (medicines) {
        if (medicines.isEmpty) {
          emit(const CatalogEmpty('No medicines available in the catalog.'));
        } else {
          emit(CatalogLoaded(medicines, isSearching: false));
        }
      },
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() =>
        'No internet connection. Please check your network and try again.',
      ServerFailure(:final message) =>
        message.isNotEmpty ? message : 'Server error occurred. Please try again.',
      CacheFailure(:final message) =>
        message.isNotEmpty ? message : 'Failed to load cached medicines.',
      ValidationFailure(:final message) => message,
      _ => failure.message,
    };
  }

  /// Debounce transformer to throttle rapid search keystrokes.
  static EventTransformer<Event> _debounce<Event>(Duration duration) {
    return (events, mapper) {
      Timer? timer;
      late StreamController<Event> controller;
      StreamSubscription<Event>? subscription;

      controller = StreamController<Event>(
        onListen: () {
          subscription = events.listen(
            (event) {
              timer?.cancel();
              timer = Timer(duration, () {
                controller.add(event);
              });
            },
            onError: controller.addError,
            onDone: () {
              timer?.cancel();
              controller.close();
            },
          );
        },
        onPause: () => subscription?.pause(),
        onResume: () => subscription?.resume(),
        onCancel: () {
          timer?.cancel();
          return subscription?.cancel();
        },
      );

      return controller.stream.asyncExpand(mapper);
    };
  }
}
