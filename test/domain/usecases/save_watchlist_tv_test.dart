import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tvs/save_tv_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvWatchlist usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveTvWatchlist(mockTvRepository);
  });

  test(
    'should save Tv to the repository',
    () async {
      // arrange
      when(
        mockTvRepository.saveTvWatchlist(testTvDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      // act
      final result = await usecase.execute(testTvDetail);
      // assert
      verify(mockTvRepository.saveTvWatchlist(testTvDetail));
      expect(result, const Right('Added to Watchlist'));
    },
  );
}
