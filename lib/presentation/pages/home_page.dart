import 'package:core/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/list/movie_list_bloc.dart';
import 'package:movie/presentation/pages/movie_section.dart';
import 'package:popular/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:popular/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:top_rated/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:top_rated/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/list/tv_list_bloc.dart';
import 'package:tv/presentation/pages/tv_section.dart';
import 'package:flutter/material.dart';
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
      context.read<TvListBloc>().add(FetchTvList());
      context.read<MovieListBloc>().add(FetchMovieList());
      context.read<PopularMoviesBloc>().add(FetchPopularMovie());
      context.read<PopularTvBloc>().add(FetchPopularTv());
      context.read<TopRatedMovieBloc>().add(FetchTopRatedMovie());
      context.read<TopRatedTvBloc>().add(FetchTopRatedTv());
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
