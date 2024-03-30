import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _nowPlayingMovies;

  MovieListBloc(this._nowPlayingMovies) : super(MovieListEmpty()) {
    on<FetchMovieList>((event, emit) async {
      emit(MovieListLoading());
      final result = await _nowPlayingMovies.execute();

      result.fold(
        (failure) => emit(MovieListError(failure)),
        (data) => emit(MovieListHasData(data)),
      );
    });
  }
}
