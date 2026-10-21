import 'package:equatable/equatable.dart';

import 'package:med_drop/features/catalog/domain/entities/medicine_entity.dart';

/// Base class for all states emitted by [CatalogBloc].
sealed class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any catalog data has been requested.
final class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

/// State emitted while medicines are being fetched or searched.
final class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

/// State emitted when medicines have been successfully retrieved.
final class CatalogLoaded extends CatalogState {
  /// The list of medicines to display.
  final List<MedicineEntity> medicines;

  /// Whether the current list is the result of an active search query.
  final bool isSearching;

  /// The active search term, if any.
  final String? query;

  const CatalogLoaded(
    this.medicines, {
    this.isSearching = false,
    this.query,
  });

  @override
  List<Object?> get props => [medicines, isSearching, query];
}

/// State emitted when a search or catalog fetch returns zero items.
final class CatalogEmpty extends CatalogState {
  final String message;

  const CatalogEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

/// State emitted when an error occurs while fetching or searching medicines.
final class CatalogError extends CatalogState {
  final String message;

  const CatalogError(this.message);

  @override
  List<Object?> get props => [message];
}
