import '../../helpers/test_helper.mocks.dart';
import 'package:watchlist/usecases/movie/get_watchlist_movie_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late GetWatchListMovieStatus usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchListMovieStatus(mockMovieRepository);
  });

  test(
    'should get watchlist status from repository',
    () async {
      // arrange
      when(
        mockMovieRepository.isAddedToMovieWatchlist(1),
      ).thenAnswer((_) async => true);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    },
  );
}
