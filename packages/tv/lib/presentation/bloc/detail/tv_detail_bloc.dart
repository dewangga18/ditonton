import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tv_status.dart';
import 'package:watchlist/usecases/tv/remove_tv_watchlist.dart';
import 'package:watchlist/usecases/tv/save_tv_watchlist.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail detailData;
  final GetTvRecommendations recommendations;
  final GetWatchListTvStatus watchListStatus;
  final SaveTvWatchlist saveWatchlist;
  final RemoveTvWatchlist removeWatchlist;

  TvDetailBloc({
    required this.detailData,
    required this.recommendations,
    required this.watchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvDetailState()) {
    on<FetchTvDetail>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final dataResult = await detailData.execute(event.id);
      final status = await loadWatchlistStatus(event.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isLoading: false,
          error: fail,
        )),
        (tv) => emit(state.copyWith(
          isLoading: false,
          data: tv,
          isWatchlist: status,
        )),
      );
    });
    on<FetchTvRecommendation>((event, emit) async {
      emit(state.copyWith(isLoadingRecommendation: true));
      final dataResult = await recommendations.execute(event.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isLoadingRecommendation: false,
          errorRecommendation: fail,
        )),
        (tv) => emit(state.copyWith(
          isLoadingRecommendation: false,
          dataRecomendation: tv,
        )),
      );
    });
    on<AddTvWatchlist>((event, emit) async {
      final dataResult = await saveWatchlist.execute(event.tv);
      final status = await loadWatchlistStatus(event.tv.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isWatchlist: false,
        )),
        (tv) => emit(state.copyWith(
          isWatchlist: status,
        )),
      );
    });
    on<DeleteTvWatchlist>((event, emit) async {
      final dataResult = await removeWatchlist.execute(event.tv);
      final status = await loadWatchlistStatus(event.tv.id);
      dataResult.fold(
        (fail) => emit(state.copyWith(
          isWatchlist: true,
        )),
        (tv) => emit(state.copyWith(
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
