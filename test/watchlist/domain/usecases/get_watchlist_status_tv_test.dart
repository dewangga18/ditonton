import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tv_status.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTvStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchListTvStatus(mockTvRepository);
  });

  test(
    'should get watchlist status from repository',
    () async {
      // arrange
      when(
        mockTvRepository.isAddedToTvWatchlist(1),
      ).thenAnswer((_) async => true);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    },
  );
}
