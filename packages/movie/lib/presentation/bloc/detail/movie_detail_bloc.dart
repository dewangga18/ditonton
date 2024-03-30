import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:watchlist/usecases/movie/get_watchlist_movie_status.dart';
import 'package:watchlist/usecases/movie/remove_movie_watchlist.dart';
import 'package:watchlist/usecases/movie/save_movie_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail detailData;
  final GetMovieRecommendations recommendations;
  final GetWatchListMovieStatus watchListStatus;
  final SaveMovieWatchlist saveWatchlist;
  final RemoveMovieWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.detailData,
    required this.recommendations,
    required this.watchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final dataResult = await detailData.execute(event.id);
      final status = await loadWatchlistStatus(event.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isLoading: false,
          error: fail,
        )),
        (movie) => emit(state.copyWith(
          isLoading: false,
          data: movie,
          isWatchlist: status,
        )),
      );
    });
    on<FetchMovieRecommendation>((event, emit) async {
      emit(state.copyWith(isLoadingRecommendation: true));
      final dataResult = await recommendations.execute(event.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isLoadingRecommendation: false,
          errorRecommendation: fail,
        )),
        (movie) => emit(state.copyWith(
          isLoadingRecommendation: false,
          dataRecomendation: movie,
        )),
      );
    });
    on<AddMovieWatchlist>((event, emit) async {
      final dataResult = await saveWatchlist.execute(event.movie);
      final status = await loadWatchlistStatus(event.movie.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isWatchlist: false,
        )),
        (movie) => emit(state.copyWith(
          isWatchlist: status,
        )),
      );
    });
    on<DeleteMovieWatchlist>((event, emit) async {
      final dataResult = await removeWatchlist.execute(event.movie);
      final status = await loadWatchlistStatus(event.movie.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isWatchlist: true,
        )),
        (movie) => emit(state.copyWith(
          isWatchlist: status,
        )),
      );
    });
  }

  Future<bool> loadWatchlistStatus(int id) async {
    final result = await watchListStatus.execute(id);
    return result;
  }
}
