part of 'movie_detail_bloc.dart';

sealed class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class FetchMovieRecommendation extends MovieDetailEvent {
  final int id;

  const FetchMovieRecommendation(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const AddMovieWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class DeleteMovieWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const DeleteMovieWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
