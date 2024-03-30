import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:top_rated/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/entities/tv.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTvs _topRatedTv;

  TopRatedTvBloc(this._topRatedTv) : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TopRatedTvLoading());
        final result = await _topRatedTv.execute();

        result.fold(
          (failure) => emit(TopRatedTvError(failure)),
          (data) => emit(TopRatedTvHasData(data)),
        );
    });
  }
}
