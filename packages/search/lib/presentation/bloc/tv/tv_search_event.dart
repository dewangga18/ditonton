part of 'tv_search_bloc.dart';

sealed class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class TvOnQueryChanged extends TvSearchEvent {
  final String query;

  const TvOnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class ClearTvList extends TvSearchEvent {}
