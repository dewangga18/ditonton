import 'package:core/core.dart';
import 'package:core/test/dummy_objects.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/detail/tv_detail_bloc.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tv_status.dart';
import 'package:watchlist/usecases/tv/remove_tv_watchlist.dart';
import 'package:watchlist/usecases/tv/save_tv_watchlist.dart';
import 'package:bloc_test/bloc_test.dart';

import 'tv_detail_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListTvStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailBloc blocDetail;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListTvStatus mockGetWatchlistStatus;
  late MockSaveTvWatchlist mockSaveWatchlist;
  late MockRemoveTvWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetWatchListTvStatus();
    mockSaveWatchlist = MockSaveTvWatchlist();
    mockRemoveWatchlist = MockRemoveTvWatchlist();
    blocDetail = TvDetailBloc(
      detailData: mockGetTvDetail as GetTvDetail,
      recommendations: mockGetTvRecommendations as GetTvRecommendations,
      watchListStatus: mockGetWatchlistStatus as GetWatchListTvStatus,
      saveWatchlist: mockSaveWatchlist as SaveTvWatchlist,
      removeWatchlist: mockRemoveWatchlist as RemoveTvWatchlist,
    );
  });

  const tId = 1;

  const tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvs = <Tv>[tTv];

  group('Get Tv Detail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should change tv when data is gotten successfully with isWatchlist',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer(
          (_) async => const Right(testTvDetail),
        );
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer(
          (_) async => true,
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(),
        blocDetail.state.copyWith(
          isLoading: false,
          data: testTvDetail,
          isWatchlist: true,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should change tv when data is gotten successfully with isNotWatchlist',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer(
          (_) async => const Right(testTvDetail),
        );
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer(
          (_) async => false,
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(),
        blocDetail.state.copyWith(
          isLoading: false,
          data: testTvDetail,
          isWatchlist: false,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should change tv when data is gotten error',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer(
          (_) async => const Left(ServerFailure('Server Failure')),
        );
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer(
          (_) async => false,
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetWatchlistStatus.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchTvDetail(tId)),
      expect: () => [
        const TvDetailState(),
        blocDetail.state.copyWith(
          isLoading: false,
          isWatchlist: false,
          error: const ServerFailure('Server Failure'),
        ),
      ],
    );
  });

  group('Get Tv Recommendations', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should change recommendation when data is gotten successfully',
      build: () {
        when(mockGetTvRecommendations.execute(tId)).thenAnswer(
          (_) async => Right(tTvs),
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchTvRecommendation(tId)),
      expect: () => [
        const TvDetailState(),
        blocDetail.state.copyWith(
          isLoadingRecommendation: false,
          dataRecomendation: tTvs,
        ),
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should change recommendation when data is gotten error',
      build: () {
        when(mockGetTvRecommendations.execute(tId)).thenAnswer(
          (_) async => const Left(ServerFailure('Server Failure')),
        );
        return blocDetail;
      },
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tId));
      },
      act: (bloc) => blocDetail.add(const FetchTvRecommendation(tId)),
      expect: () => [
        const TvDetailState(),
        blocDetail.state.copyWith(
          isLoadingRecommendation: false,
          errorRecommendation: const ServerFailure('Server Failure'),
        ),
      ],
    );

    group('Watchlist', () {
      blocTest<TvDetailBloc, TvDetailState>(
        'should return isWatchlist true when success',
        build: () {
          when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer(
            (_) async => const Right('Added to Watchlist'),
          );
          when(mockGetWatchlistStatus.execute(12513)).thenAnswer(
            (_) async => true,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockSaveWatchlist.execute(testTvDetail));
          verify(mockGetWatchlistStatus.execute(12513));
        },
        act: (bloc) => blocDetail.add(const AddTvWatchlist(testTvDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: true,
          ),
        ],
      );

      blocTest<TvDetailBloc, TvDetailState>(
        'should return isWatchlist false when error',
        build: () {
          when(mockSaveWatchlist.execute(testTvDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database Failure')),
          );
          when(mockGetWatchlistStatus.execute(12513)).thenAnswer(
            (_) async => false,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockSaveWatchlist.execute(testTvDetail));
          verify(mockGetWatchlistStatus.execute(12513));
        },
        act: (bloc) => blocDetail.add(const AddTvWatchlist(testTvDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: false,
          ),
        ],
      );

      blocTest<TvDetailBloc, TvDetailState>(
        'should return isWatchlist false when success remove',
        build: () {
          when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer(
            (_) async => const Right('Removed from Watchlist'),
          );
          when(mockGetWatchlistStatus.execute(12513)).thenAnswer(
            (_) async => false,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockRemoveWatchlist.execute(testTvDetail));
          verify(mockGetWatchlistStatus.execute(12513));
        },
        act: (bloc) => blocDetail.add(const DeleteTvWatchlist(testTvDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: false,
          ),
        ],
      );

      blocTest<TvDetailBloc, TvDetailState>(
        'should return isWatchlist true when failed remove',
        build: () {
          when(mockRemoveWatchlist.execute(testTvDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database Failure')),
          );
          when(mockGetWatchlistStatus.execute(12513)).thenAnswer(
            (_) async => true,
          );
          return blocDetail;
        },
        verify: (bloc) {
          verify(mockRemoveWatchlist.execute(testTvDetail));
          verify(mockGetWatchlistStatus.execute(12513));
        },
        act: (bloc) => blocDetail.add(const DeleteTvWatchlist(testTvDetail)),
        expect: () => [
          blocDetail.state.copyWith(
            isWatchlist: true,
          ),
        ],
      );
    });
  });
}
