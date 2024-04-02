import 'package:core/test/dummy_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/usecases/tv/remove_tv_watchlist.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvWatchlist usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveTvWatchlist(mockTvRepository);
  });

  test(
    'should remove watchlist Tv from repository',
    () async {
      // arrange
      when(
        mockTvRepository.removeTvWatchlist(testTvDetail),
      ).thenAnswer((_) async => const Right('Removed from watchlist'));
      // act
      final result = await usecase.execute(testTvDetail);
      // assert
      verify(mockTvRepository.removeTvWatchlist(testTvDetail));
      expect(result, const Right('Removed from watchlist'));
    },
  );
}
