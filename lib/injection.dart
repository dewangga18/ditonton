import 'package:http/http.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/repository/movie_repository_impl.dart';
import 'package:movie/domain/repository/movie_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/list/movie_list_bloc.dart';
import 'package:popular/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:popular/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:popular/usecases/get_popular_movies.dart';
import 'package:popular/usecases/get_popular_tvs.dart';
import 'package:search/presentation/bloc/movie/movie_search_bloc.dart';
import 'package:search/presentation/bloc/tv/tv_search_bloc.dart';
import 'package:search/usecases/search_movies.dart';
import 'package:search/usecases/search_tv.dart';
import 'package:top_rated/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:top_rated/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:top_rated/usecases/get_top_rated_movies.dart';
import 'package:top_rated/usecases/get_top_rated_tvs.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/repository/tv_repository_impl.dart';
import 'package:tv/presentation/bloc/detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/list/tv_list_bloc.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tv/domain/repository/tv_repository.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:watchlist/data/database_helper.dart';
import 'package:watchlist/usecases/movie/get_watchlist_movie_status.dart';
import 'package:watchlist/usecases/movie/get_watchlist_movies.dart';
import 'package:watchlist/usecases/movie/remove_movie_watchlist.dart';
import 'package:watchlist/usecases/movie/save_movie_watchlist.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tv_status.dart';
import 'package:watchlist/usecases/tv/get_watchlist_tvs.dart';
import 'package:watchlist/usecases/tv/remove_tv_watchlist.dart';
import 'package:watchlist/usecases/tv/save_tv_watchlist.dart';

final locator = GetIt.instance;

void init(Client client) async {
  /// provider
  locator.registerFactory(
    () => MovieListBloc(locator()),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      detailData: locator(),
      recommendations: locator(),
      watchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchBloc(locator()),
  );
  locator.registerFactory(
    () => TvSearchBloc(locator()),
  );
  locator.registerFactory(
    () => PopularMoviesBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedMovieBloc(locator()),
  );
  locator.registerFactory(
    () => TvListBloc(locator()),
  );
  locator.registerFactory(
    () => TvDetailBloc(
      detailData: locator(),
      recommendations: locator(),
      watchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedTvBloc(locator()),
  );
  locator.registerFactory(
    () => WatchlistMovieBloc(locator()),
  );
  locator.registerFactory(
    () => WatchlistTvBloc(locator()),
  );

  /// use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListMovieStatus(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetWatchListTvStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));

  /// repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  /// data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
  );

  /// helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  /// external
  locator.registerLazySingleton(() => client);
}
