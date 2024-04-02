part of 'movie_search_bloc.dart';

sealed class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class MovieOnQueryChanged extends MovieSearchEvent {
  final String query;

  const MovieOnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class ClearMovieList extends MovieSearchEvent {}
