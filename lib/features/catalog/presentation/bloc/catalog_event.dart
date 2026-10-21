import 'package:equatable/equatable.dart';

/// Base class for all events dispatched to [CatalogBloc].
sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched to load the medicine catalog.
///
/// When [forceRefresh] is `true`, the local cache is bypassed to fetch
/// fresh records from the remote source.
final class LoadCatalogEvent extends CatalogEvent {
  final bool forceRefresh;

  const LoadCatalogEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// Dispatched when the user enters or changes search query text.
final class SearchCatalogEvent extends CatalogEvent {
  final String query;

  const SearchCatalogEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Dispatched to reset search input and restore the full medicine catalog.
final class ClearSearchEvent extends CatalogEvent {
  const ClearSearchEvent();
}
