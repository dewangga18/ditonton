part of 'watchlist_movie_bloc.dart';

sealed class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object?> get props => [];
}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieEmpty extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final Failure error;

  const WatchlistMovieError(this.error);

  @override
  List<Object?> get props => [error];
}

class WatchlistMovieHasData extends WatchlistMovieState {
  final List<Movie> result;

  const WatchlistMovieHasData(this.result);

  @override
  List<Object?> get props => [result];
}
