import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/usecases/search_tv.dart';
import 'package:tv/domain/entities/tv.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs _searchTvs;
  TvSearchBloc(this._searchTvs) : super(TvSearchEmpty()) {
    on<TvOnQueryChanged>(
      (event, emit) async {
        final query = event.query;
        if (query.isEmpty) {
          emit(TvSearchEmpty());
          return;
        }

        emit(TvSearchLoading());
        final result = await _searchTvs.execute(query);

        result.fold(
          (failure) => emit(TvSearchError(failure.message)),
          (data) => emit(TvSearchHasData(data)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<ClearTvList>((event, emit) {
      emit(TvSearchEmpty());
    });
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
