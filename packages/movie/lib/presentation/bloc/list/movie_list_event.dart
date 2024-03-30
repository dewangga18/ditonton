part of 'movie_list_bloc.dart';

sealed class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieList extends MovieListEvent {}
