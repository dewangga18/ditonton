import 'package:core/test/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  const tId = 1;

  test(
    'should get tv detail from the repository',
    () async {
      // arrange
      when(
        mockTvRepository.getTvDetail(tId),
      ).thenAnswer((_) async => const Right(testTvDetail));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, const Right(testTvDetail));
    },
  );
}
