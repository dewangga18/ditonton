import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:core/model/genre_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/repository/tv_repository_impl.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:core/test/dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTvModel = TvModel(
    adult: false,
    backdropPath: "/9wLRrDBRGtCD68BRF7BsD0RHHQ3.jpg",
    genreIds: [10759, 16, 35, 10765],
    id: 65733,
    originCountry: ["JP"],
    originalLanguage: "ja",
    originalName: "originalName",
    overview:
        "Robotic cat Doraemon is sent back in time from the 22nd century to protect 10-year-old Noby, a lazy and uncoordinated boy who is destined to have a tragic future. Doraemon can create secret gadgets from a pocket on his stomach, but they usually cause more bad than good because of Nobys propensity to misuse them.",
    popularity: 829.85,
    posterPath: "/9ZN1P32SHviL3SV51qLivxycvcx.jpg",
    firstAirDate: "2005-04-22",
    name: "Doraemon",
    voteAverage: 7.7,
    voteCount: 100,
  );

  const tTv = Tv(
    adult: false,
    backdropPath: "/9wLRrDBRGtCD68BRF7BsD0RHHQ3.jpg",
    genreIds: [10759, 16, 35, 10765],
    id: 65733,
    originCountry: ["JP"],
    originalLanguage: "ja",
    originalName: "originalName",
    overview:
        "Robotic cat Doraemon is sent back in time from the 22nd century to protect 10-year-old Noby, a lazy and uncoordinated boy who is destined to have a tragic future. Doraemon can create secret gadgets from a pocket on his stomach, but they usually cause more bad than good because of Nobys propensity to misuse them.",
    popularity: 829.85,
    posterPath: "/9ZN1P32SHviL3SV51qLivxycvcx.jpg",
    firstAirDate: "2005-04-22",
    name: "Doraemon",
    voteAverage: 7.7,
    voteCount: 100,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  group('Now Playing Tvs', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingTvs(),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getNowPlayingTvs();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTvs());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingTvs(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingTvs();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getNowPlayingTvs(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getNowPlayingTvs();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTvs());
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Popular Tvs', () {
    test(
      'should return Tv list when call to data source is success',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvs(),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getPopularTvs();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvs(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvs();
        // assert
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvs(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTvs();
        // assert
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated Tvs', () {
    test(
      'should return Tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvs(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get Tv Detail', () {
    const tId = 1;

    const tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: '/3oZgE4220UrqaaiZXxz5MtNCVxJ.jpg',
      genres: [GenreModel(id: 10764, name: 'Reality')],
      homepage: '',
      id: 12513,
      inProduction: true,
      name: 'Operación Triunfo',
      numberOfEpisodes: 248,
      numberOfSeasons: 12,
      originalLanguage: 'es',
      originalName: 'Operación Triunfo',
      overview:
          'Reality-show talent contest aimed to find the country\'s next solo singing sensation, putting a selection of hopefuls through their paces by getting them to sing a variety of cover versions of popular songs, with tutoring from various professionals.',
      popularity: 2092.564,
      posterPath: '/8Qfq22zP5PeUKJfN5bFPFJtJz5i.jpg',
      status: 'Returning Series',
      tagline: '',
      type: 'Reality',
      voteAverage: 6.389,
      voteCount: 18,
    );

    test(
      'should return Tv data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenAnswer((_) async => tTvResponse);
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(const Right(testTvDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvDetail(tId),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModel>[];
    const tId = 1;

    test(
      'should return data (Tv list) when the call is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenAnswer((_) async => tTvList);
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvRecommendations(tId);
        // assertbuild runner
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvRecommendations(tId),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Seach Tvs', () {
    const tQuery = 'spiderman';

    test(
      'should return Tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvs(tQuery),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test(
      'should return success message when saving successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.insertTvWatchlist(testTvTable),
        ).thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveTvWatchlist(testTvDetail);
        // assert
        expect(result, const Right('Added to Watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when saving unsuccessful',
      () async {
        // arrange
        when(
          mockLocalDataSource.insertTvWatchlist(testTvTable),
        ).thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveTvWatchlist(testTvDetail);
        // assert
        expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove successful',
      () async {
        // arrange
        when(
          mockLocalDataSource.removeTvWatchlist(testTvTable),
        ).thenAnswer((_) async => 'Removed from watchlist');
        // act
        final result = await repository.removeTvWatchlist(testTvDetail);
        // assert
        expect(result, const Right('Removed from watchlist'));
      },
    );

    test(
      'should return DatabaseFailure when remove unsuccessful',
      () async {
        // arrange
        when(
          mockLocalDataSource.removeTvWatchlist(testTvTable),
        ).thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeTvWatchlist(testTvDetail);
        // assert
        expect(
          result,
          const Left(DatabaseFailure('Failed to remove watchlist')),
        );
      },
    );
  });

  group('get watchlist status', () {
    test(
      'should return watch status whether data is found',
      () async {
        // arrange
        const tId = 1;
        when(
          mockLocalDataSource.getTvById(tId),
        ).thenAnswer((_) async => null);
        // act
        final result = await repository.isAddedToTvWatchlist(tId);
        // assert
        expect(result, false);
      },
    );
  });

  group('get watchlist Tvs', () {
    test(
      'should return list of Tvs',
      () async {
        // arrange
        when(
          mockLocalDataSource.getWatchlistTvs(),
        ).thenAnswer((_) async => [testTvTable]);
        // act
        final result = await repository.getWatchlistTvs();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testWatchlistTv]);
      },
    );
  });
}
