import 'package:core/utils/routes.dart';
import 'package:movie/presentation/pages/movie_section.dart';
import 'package:movie/presentation/providers/movie_list_notifier.dart';
import 'package:tv/presentation/pages/tv_section.dart';
import 'package:tv/presentation/providers/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/tv/watchlist_tv_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
      Provider.of<TvListNotifier>(context, listen: false)
        ..fetchNowPlayingTvs()
        ..fetchPopularTvs()
        ..fetchTopRatedTvs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                setState(() => index = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_tv_rounded),
              title: const Text('TV'),
              onTap: () {
                setState(() => index = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_ROUTE);
                context.read<WatchlistMovieBloc>().add(FetchWatchlistMovie());
                context.read<WatchlistTvBloc>().add(FetchWatchlistTv());
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: IndexedStack(
        index: index,
        children: const [
          MovieSection(),
          TvSection(),
        ],
      ),
    );
  }
}
