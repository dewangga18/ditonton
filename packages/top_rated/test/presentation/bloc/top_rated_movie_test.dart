import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:top_rated/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:top_rated/usecases/get_top_rated_movies.dart';

import 'top_rated_movie_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMovieBloc blocTopRated;
  late MockGetTopRatedMovies mockTopRated;

  setUp(() {
    mockTopRated = MockGetTopRatedMovies();
    blocTopRated = TopRatedMovieBloc(mockTopRated as GetTopRatedMovies);
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

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should change movies data when data is gotten successfully',
    build: () {
      when(mockTopRated.execute()).thenAnswer(
        (_) async => Right(tMovieList),
      );
      return blocTopRated;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovie()),
    verify: (bloc) {
      verify(mockTopRated.execute());
    },
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieHasData(tMovieList),
    ],
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockTopRated.execute()).thenAnswer(
        (_) async => const Left(ServerFailure('Server Failure')),
      );
      return blocTopRated;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovie()),
    verify: (bloc) {
      verify(mockTopRated.execute());
    },
    expect: () => [
      TopRatedMovieLoading(),
      const TopRatedMovieError(ServerFailure('Server Failure')),
    ],
  );
}
