import 'package:core/utils/exception.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:core/test/dummy_objects.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertTvWatchlist(testTvTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertTvWatchlist(testTvTable);
        // assert
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertTvWatchlist(testTvTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.insertTvWatchlist(testTvTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeTvWatchlist(testTvTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.removeTvWatchlist(testTvTable);
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeTvWatchlist(testTvTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.removeTvWatchlist(testTvTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get TV Detail By Id', () {
    const tId = 1;

    test(
      'should return TV Detail Table when data is found',
      () async {
        // arrange
        when(
          mockDatabaseHelper.getTvById(tId),
        ).thenAnswer((_) async => testTvMap);
        // act
        final result = await dataSource.getTvById(tId);
        // assert
        expect(result, testTvTable);
      },
    );

    test(
      'should return null when data is not found',
      () async {
        // arrange
        when(
          mockDatabaseHelper.getTvById(tId),
        ).thenAnswer((_) async => null);
        // act
        final result = await dataSource.getTvById(tId);
        // assert
        expect(result, null);
      },
    );
  });

  group('get watchlist tv', () {
    test(
      'should return list of TvTable from database',
      () async {
        // arrange
        when(
          mockDatabaseHelper.getWatchlistTvs(),
        ).thenAnswer((_) async => [testTvMap]);
        // act
        final result = await dataSource.getWatchlistTvs();
        // assert
        expect(result, [testTvTable]);
      },
    );
  });
}
