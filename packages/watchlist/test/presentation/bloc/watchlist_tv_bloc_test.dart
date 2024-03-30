import 'package:core/test/dummy_data/dummy_objects.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tvs.dart';

import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvBloc watchlistBloc;
  late MockGetWatchlistTvs mockWatchlist;

  setUp(() {
    mockWatchlist = MockGetWatchlistTvs();
    watchlistBloc = WatchlistTvBloc(mockWatchlist);
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'should change movies data when data is gotten successfully',
    build: () {
      when(mockWatchlist.execute()).thenAnswer(
        (_) async => const Right([testWatchlistTv]),
      );
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    verify: (bloc) {
      verify(mockWatchlist.execute());
    },
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvHasData([testWatchlistTv]),
    ],
  );
  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockWatchlist.execute()).thenAnswer(
        (_) async => const Left(DatabaseFailure("Can't get data")),
      );
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    verify: (bloc) {
      verify(mockWatchlist.execute());
    },
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvError(DatabaseFailure("Can't get data")),
    ],
  );
}
