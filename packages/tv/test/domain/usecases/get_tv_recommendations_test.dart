import '../../helpers/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  const tId = 1;
  final tTvs = <Tv>[];

  test(
    'should get list of Tv recommendations from the repository',
    () async {
      // arrange
      when(
        mockTvRepository.getTvRecommendations(tId),
      ).thenAnswer((_) async => Right(tTvs));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tTvs));
    },
  );
}
