import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:popular/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:popular/usecases/get_popular_movies.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';

import 'popular_movie_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc blocPopular;
  late MockGetPopularMovies mockPopular;

  setUp(() {
    mockPopular = MockGetPopularMovies();
    blocPopular = PopularMoviesBloc(mockPopular as GetPopularMovies);
  });

  const tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should change movies data when data is gotten successfully',
    build: () {
      when(mockPopular.execute()).thenAnswer(
        (_) async => Right(tMovieList),
      );
      return blocPopular;
    },
    act: (bloc) => bloc.add(FetchPopularMovie()),
    verify: (bloc) {
      verify(mockPopular.execute());
    },
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesHasData(tMovieList),
    ],
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockPopular.execute()).thenAnswer(
        (_) async => const Left(ServerFailure('Server Failure')),
      );
      return blocPopular;
    },
    act: (bloc) => bloc.add(FetchPopularMovie()),
    verify: (bloc) {
      verify(mockPopular.execute());
    },
    expect: () => [
      PopularMoviesLoading(),
      const PopularMoviesError(ServerFailure('Server Failure')),
    ],
  );
}
