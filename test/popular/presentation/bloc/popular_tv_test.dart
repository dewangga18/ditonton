import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:popular/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:popular/usecases/get_popular_tvs.dart';
import 'package:tv/domain/entities/tv.dart';

import 'popular_tv_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvBloc blocPopular;
  late MockGetPopularTvs mockPopular;

  setUp(() {
    mockPopular = MockGetPopularTvs();
    blocPopular = PopularTvBloc(mockPopular as GetPopularTvs);
  });

  const tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvList = <Tv>[tTv];

  blocTest<PopularTvBloc, PopularTvState>(
    'should change Tv data when data is gotten successfully',
    build: () {
      when(mockPopular.execute()).thenAnswer(
        (_) async => Right(tTvList),
      );
      return blocPopular;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    verify: (bloc) {
      verify(mockPopular.execute());
    },
    expect: () => [
      PopularTvLoading(),
      PopularTvHasData(tTvList),
    ],
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockPopular.execute()).thenAnswer(
        (_) async => const Left(ServerFailure('Server Failure')),
      );
      return blocPopular;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    verify: (bloc) {
      verify(mockPopular.execute());
    },
    expect: () => [
      PopularTvLoading(),
      const PopularTvError(ServerFailure('Server Failure')),
    ],
  );
}
