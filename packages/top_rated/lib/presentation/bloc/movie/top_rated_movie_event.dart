part of 'top_rated_movie_bloc.dart';

sealed class TopRatedMovieEvent extends Equatable {
  const TopRatedMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovie extends TopRatedMovieEvent {}