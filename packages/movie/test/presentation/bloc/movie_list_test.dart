import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/list/movie_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'movie_list_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MovieListBloc blocList;
  late MockGetNowPlayingMovies mockList;

  setUp(() {
    mockList = MockGetNowPlayingMovies();
    blocList = MovieListBloc(mockList as GetNowPlayingMovies);
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

  test('initialState should be empty', () {
    expect(blocList.state, equals(MovieListEmpty()));
  });

  blocTest<MovieListBloc, MovieListState>(
    'should change movies data when data is gotten successfully',
    build: () {
      when(mockList.execute()).thenAnswer(
        (_) async => Right(tMovieList),
      );
      return blocList;
    },
    act: (bloc) => bloc.add(FetchMovieList()),
    verify: (bloc) {
      verify(mockList.execute());
    },
    expect: () => [
      MovieListLoading(),
      MovieListHasData(tMovieList),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockList.execute()).thenAnswer(
        (_) async => const Left(ServerFailure('Server Failure')),
      );
      return blocList;
    },
    act: (bloc) => bloc.add(FetchMovieList()),
    verify: (bloc) {
      verify(mockList.execute());
    },
    expect: () => [
      MovieListLoading(),
      const MovieListError(ServerFailure('Server Failure')),
    ],
  );
}
