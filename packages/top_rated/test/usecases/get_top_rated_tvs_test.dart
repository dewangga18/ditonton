import '../../../tv/test/helpers/test_helper.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:top_rated/usecases/get_top_rated_tvs.dart';


void main() {
  late GetTopRatedTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTopRatedTvs(mockTvRepository);
  });

  final tTvs = <Tv>[];

  test(
    'should get list of Tvs from repository',
    () async {
      // arrange
      when(
        mockTvRepository.getTopRatedTvs(),
      ).thenAnswer((_) async => Right(tTvs));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTvs));
    },
  );
}
