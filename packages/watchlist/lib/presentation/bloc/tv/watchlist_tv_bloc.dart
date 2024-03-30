import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tvs.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs _watchlist;
  WatchlistTvBloc(this._watchlist) : super(WatchlistTvEmpty()) {
    on<WatchlistTvEvent>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await _watchlist.execute();
      result.fold(
        (failure) => emit(WatchlistTvError(failure)),
        (data) => emit(WatchlistTvHasData(data)),
      );
    });
  }
}
