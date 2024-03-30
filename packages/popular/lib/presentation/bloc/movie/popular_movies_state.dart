part of 'popular_movies_bloc.dart';

sealed class PopularMoviesState extends Equatable {
  const PopularMoviesState();
  
  @override
  List<Object> get props => [];
}

final class PopularMoviesEmpty extends PopularMoviesState {}

final class PopularMoviesLoading extends PopularMoviesState {}

final class PopularMoviesError extends PopularMoviesState {
  final Failure error;

  const PopularMoviesError(this.error);
  @override
  List<Object> get props => [error];
}

final class PopularMoviesHasData extends PopularMoviesState {
  final List<Movie> result;

  const PopularMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}

