import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/usecases/search_movies.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _searchMovies;

  MovieSearchBloc(this._searchMovies) : super(MovieSearchEmpty()) {
    on<MovieOnQueryChanged>(
      (event, emit) async {
        final query = event.query;
        if (query.isEmpty) {
          emit(MovieSearchEmpty());
          return;
        }

        emit(MovieSearchLoading());
        final result = await _searchMovies.execute(query);

        result.fold(
          (failure) => emit(MovieSearchError(failure.message)),
          (data) => emit(MovieSearchHasData(data)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<ClearMovieList>((event, emit) {
      emit(MovieSearchEmpty());
    });
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
