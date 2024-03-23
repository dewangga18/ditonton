import 'package:core/test/dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tvs.dart';

void main() {
  late GetWatchlistTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTvs(mockTvRepository);
  });

  test(
    'should get list of Tvs from the repository',
    () async {
      // arrange
      when(
        mockTvRepository.getWatchlistTvs(),
      ).thenAnswer((_) async => Right(testTvList));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(testTvList));
    },
  );
}
