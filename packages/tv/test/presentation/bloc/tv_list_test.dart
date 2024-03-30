import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv/presentation/bloc/list/tv_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'tv_list_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvs])
void main() {
  late TvListBloc blocList;
  late MockGetNowPlayingTvs mockList;

  setUp(() {
    mockList = MockGetNowPlayingTvs();
    blocList = TvListBloc(mockList as GetNowPlayingTvs);
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
  test('initialState should be empty', () {
    expect(blocList.state, equals(TvListEmpty()));
  });

  blocTest<TvListBloc, TvListState>(
    'should change Tvs data when data is gotten successfully',
    build: () {
      when(mockList.execute()).thenAnswer(
        (_) async => Right(tTvList),
      );
      return blocList;
    },
    act: (bloc) => bloc.add(FetchTvList()),
    verify: (bloc) {
      verify(mockList.execute());
    },
    expect: () => [
      TvListLoading(),
      TvListHasData(tTvList),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockList.execute()).thenAnswer(
        (_) async => const Left(ServerFailure('Server Failure')),
      );
      return blocList;
    },
    act: (bloc) => bloc.add(FetchTvList()),
    verify: (bloc) {
      verify(mockList.execute());
    },
    expect: () => [
      TvListLoading(),
      const TvListError(ServerFailure('Server Failure')),
    ],
  );
}
