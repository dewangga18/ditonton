import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:popular/usecases/get_popular_tvs.dart';
import 'package:tv/domain/entities/tv.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTvs _popularTv;

  PopularTvBloc(this._popularTv) : super(PopularTvEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(PopularTvLoading());
      final result = await _popularTv.execute();

      result.fold(
        (failure) => emit(PopularTvError(failure)),
        (data) => emit(PopularTvHasData(data)),
      );
    });
  }
}
