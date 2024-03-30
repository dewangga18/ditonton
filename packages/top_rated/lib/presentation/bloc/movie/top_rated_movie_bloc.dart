import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:top_rated/usecases/get_top_rated_movies.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies _topRatedMovie;

  TopRatedMovieBloc(this._topRatedMovie) : super(TopRatedMovieEmpty()) {
    on<FetchTopRatedMovie>((event, emit) async {
      emit(TopRatedMovieLoading());
        final result = await _topRatedMovie.execute();

        result.fold(
          (failure) => emit(TopRatedMovieError(failure)),
          (data) => emit(TopRatedMovieHasData(data)),
        );
    });
  }
}
