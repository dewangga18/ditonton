import 'package:bloc/bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:popular/usecases/get_popular_movies.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _popularMovies;

  PopularMoviesBloc(this._popularMovies) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovie>((event, emit) async {
      emit(PopularMoviesLoading());
        final result = await _popularMovies.execute();
        
        result.fold(
          (failure) => emit(PopularMoviesError(failure)),
          (data) => emit(PopularMoviesHasData(data)),
        );
    });
  }
}
