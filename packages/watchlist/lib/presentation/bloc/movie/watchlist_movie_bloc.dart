import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:watchlist/usecases/movie/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _watchlist;

  WatchlistMovieBloc(this._watchlist) : super(WatchlistMovieEmpty()) {
    on<WatchlistMovieEvent>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await _watchlist.execute();
      result.fold(
        (failure) => emit(WatchlistMovieError(failure)),
        (data) => emit(WatchlistMovieHasData(data)),
      );
    });
  }
}
