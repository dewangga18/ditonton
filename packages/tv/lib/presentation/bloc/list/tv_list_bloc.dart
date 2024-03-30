import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTvs _nowPlayingTvs;

  TvListBloc(this._nowPlayingTvs) : super(TvListEmpty()) {
    on<FetchTvList>((event, emit) async {
      emit(TvListLoading());
      final result = await _nowPlayingTvs.execute();

      result.fold(
        (failure) => emit(TvListError(failure)),
        (data) => emit(TvListHasData(data)),
      );
    });
  }
}
