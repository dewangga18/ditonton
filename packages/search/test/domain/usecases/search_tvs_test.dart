import '../../helpers/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:search/usecases/search_tv.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


void main() {
  late SearchTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTvs(mockTvRepository);
  });

  final tTvs = <Tv>[];
  const tQuery = 'Doraemon';

  test(
    'should get list of Tvs from the repository',
    () async {
      // arrange
      when(
        mockTvRepository.searchTvs(tQuery),
      ).thenAnswer((_) async => Right(tTvs));
      // act
      final result = await usecase.execute(tQuery);
      // assert
      expect(result, Right(tTvs));
    },
  );
}
