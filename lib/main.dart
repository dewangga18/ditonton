import 'package:about/presentation/about_page.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:popular/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:popular/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:top_rated/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:top_rated/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:top_rated/presentation/pages/top_rated_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/utils/ssl_pinning.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular/presentation/pages/popular_page.dart';
import 'package:search/presentation/bloc/movie/movie_search_bloc.dart';
import 'package:search/presentation/bloc/tv/tv_search_bloc.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:watchlist/presentation/page/watchlist_page.dart';
import 'package:movie/presentation/providers/movie_detail_notifier.dart';
import 'package:movie/presentation/providers/movie_list_notifier.dart';
import 'package:tv/presentation/providers/tv_detail_notifier.dart';
import 'package:tv/presentation/providers/tv_list_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/presentation/pages/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// [update] impement ssl pinning
  final client = await getSSLPinningClient();
  di.init(client);
  /// [firebase] init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvDetailNotifier>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HOME_ROUTE:
              return MaterialPageRoute(builder: (_) => const HomePage());
            case POPULAR_ROUTE:
              final index = settings.arguments as int;
              return CupertinoPageRoute(
                builder: (_) => PopularPage(index: index),
              );
            case TOP_RATED_ROUTE:
              final index = settings.arguments as int;
              return CupertinoPageRoute(
                builder: (_) => TopRatedPage(index: index),
              );
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TV_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_ROUTE:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case WATCHLIST_ROUTE:
              return MaterialPageRoute(
                builder: (_) => const WatchlistPage(),
              );
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
