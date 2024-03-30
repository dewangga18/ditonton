import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:top_rated/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:top_rated/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/entities/tv.dart';

import 'top_rated_tv_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvBloc blocTopRated;
  late MockGetTopRatedTvs mockTopRated;

  setUp(() {
    mockTopRated = MockGetTopRatedTvs();
    blocTopRated = TopRatedTvBloc(mockTopRated as GetTopRatedTvs);
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

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should change Tv data when data is gotten successfully',
    build: () {
      when(mockTopRated.execute()).thenAnswer(
        (_) async => Right(tTvList),
      );
      return blocTopRated;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    verify: (bloc) {
      verify(mockTopRated.execute());
    },
    expect: () => [
      TopRatedTvLoading(),
      TopRatedTvHasData(tTvList),
    ],
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockTopRated.execute()).thenAnswer(
        (_) async => const Left(ServerFailure('Server Failure')),
      );
      return blocTopRated;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    verify: (bloc) {
      verify(mockTopRated.execute());
    },
    expect: () => [
      TopRatedTvLoading(),
      const TopRatedTvError(ServerFailure('Server Failure')),
    ],
  );
}
