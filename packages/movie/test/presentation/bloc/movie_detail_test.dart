import 'package:bloc_test/bloc_test.dart';
import 'package:core/test/dummy_data/dummy_objects.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/presentation/bloc/detail/movie_detail_bloc.dart';
import 'package:watchlist/usecases/movie/get_watchlist_movie_status.dart';
import 'package:watchlist/usecases/movie/remove_movie_watchlist.dart';
import 'package:watchlist/usecases/movie/save_movie_watchlist.dart';

import 'movie_detail_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListMovieStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieDetailBloc blocDetail;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListMovieStatus mockGetWatchlistStatus;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveMovieWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveMovieWatchlist();
    blocDetail = MovieDetailBloc(
      detailData: mockGetMovieDetail as GetMovieDetail,
      recommendations: mockGetMovieRecommendations as GetMovieRecommendations,
      watchListStatus: mockGetWatchlistStatus as GetWatchListMovieStatus,
      saveWatchlist: mockSaveWatchlist as SaveMovieWatchlist,
      removeWatchlist: mockRemoveWatchlist as RemoveMovieWatchlist,
    );
  });

  const tId = 1;

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
  final tMovies = <Movie>[tMovie];

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should change Movie when data is gotten successfully with isWatchlist',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
          (_) async => const Right(testMovieDetail),
        );
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer(
          (_) async => true,
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(),
        blocDetail.state.copyWith(
          isLoading: false,
          data: testMovieDetail,
          isWatchlist: true,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should change Movie when data is gotten successfully with isNotWatchlist',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
          (_) async => const Right(testMovieDetail),
        );
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer(
          (_) async => false,
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(),
        blocDetail.state.copyWith(
          isLoading: false,
          data: testMovieDetail,
          isWatchlist: false,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should change Movie when data is gotten error',
      build: () {
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
          (_) async => const Left(ServerFailure('Server Failure')),
        );
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer(
          (_) async => false,
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(),
        blocDetail.state.copyWith(
          isLoading: false,
          isWatchlist: false,
          error: const ServerFailure('Server Failure'),
        ),
      ],
    );
  });

  group('Get Movie Recommendations', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should change recommendation when data is gotten successfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
          (_) async => Right(tMovies),
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchMovieRecommendation(tId)),
      expect: () => [
        const MovieDetailState(),
        blocDetail.state.copyWith(
          isLoadingRecommendation: false,
          dataRecomendation: tMovies,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should change recommendation when data is gotten error',
      build: () {
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
          (_) async => const Left(ServerFailure('Server Failure')),
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchMovieRecommendation(tId)),
      expect: () => [
        const MovieDetailState(),
        blocDetail.state.copyWith(
          isLoadingRecommendation: false,
          errorRecommendation: const ServerFailure('Server Failure'),
        ),
      ],
    );

    group('Watchlist', () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'should return isWatchlist true when success',
        build: () {
          when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Right('Added to Watchlist'),
          );
          when(mockGetWatchlistStatus.execute(1)).thenAnswer(
            (_) async => true,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockSaveWatchlist.execute(testMovieDetail));
          verify(mockGetWatchlistStatus.execute(1));
        },
        act: (bloc) => blocDetail.add(const AddMovieWatchlist(testMovieDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: true,
          ),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'should return isWatchlist false when error',
        build: () {
          when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database Failure')),
          );
          when(mockGetWatchlistStatus.execute(1)).thenAnswer(
            (_) async => false,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockSaveWatchlist.execute(testMovieDetail));
          verify(mockGetWatchlistStatus.execute(1));
        },
        act: (bloc) => blocDetail.add(const AddMovieWatchlist(testMovieDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: false,
          ),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'should return isWatchlist false when success remove',
        build: () {
          when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Right('Removed from Watchlist'),
          );
          when(mockGetWatchlistStatus.execute(1)).thenAnswer(
            (_) async => false,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockRemoveWatchlist.execute(testMovieDetail));
          verify(mockGetWatchlistStatus.execute(1));
        },
        act: (bloc) =>
            blocDetail.add(const DeleteMovieWatchlist(testMovieDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: false,
          ),
        ],
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'should return isWatchlist true when failed remove',
        build: () {
          when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database Failure')),
          );
          when(mockGetWatchlistStatus.execute(1)).thenAnswer(
            (_) async => true,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockRemoveWatchlist.execute(testMovieDetail));
          verify(mockGetWatchlistStatus.execute(1));
        },
        act: (bloc) =>
            blocDetail.add(const DeleteMovieWatchlist(testMovieDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: true,
          ),
        ],
      );
    });
  });
}
