part of 'watchlist_tv_bloc.dart';

sealed class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object?> get props => [];
}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvEmpty extends WatchlistTvState {}

class WatchlistTvError extends WatchlistTvState {
  final Failure error;

  const WatchlistTvError(this.error);

  @override
  List<Object?> get props => [error];
}

class WatchlistTvHasData extends WatchlistTvState {
  final List<Tv> result;

  const WatchlistTvHasData(this.result);

  @override
  List<Object?> get props => [result];
}
