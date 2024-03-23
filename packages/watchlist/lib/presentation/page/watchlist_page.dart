import 'package:core/core.dart';
import 'package:core/utils/utils.dart';
import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:watchlist/presentation/provider/tv/watchlist_tv_notifier.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(
        context,
        listen: false,
      ).fetchWatchlistMovies();
      Provider.of<WatchlistTvNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTvs();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(
      context,
      listen: false,
    ).fetchWatchlistMovies();
    Provider.of<WatchlistTvNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTvs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TabBar(
                labelStyle: kSubtitle,
                unselectedLabelStyle: kSubtitle,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Movie'),
                  Tab(text: 'TV'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Consumer<WatchlistMovieNotifier>(
                      builder: (context, data, child) {
                        if (data.watchlistState == RequestState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (data.watchlistState == RequestState.loaded) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              final movie = data.watchlistMovies[index];
                              return CardList(movie: movie);
                            },
                            itemCount: data.watchlistMovies.length,
                          );
                        } else {
                          return Center(
                            key: const Key('error_message'),
                            child: Text(data.message),
                          );
                        }
                      },
                    ),
                    Consumer<WatchlistTvNotifier>(
                      builder: (context, data, child) {
                        if (data.watchlistState == RequestState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (data.watchlistState == RequestState.loaded) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              final tv = data.watchlistTvs[index];
                              return CardList(tv: tv);
                            },
                            itemCount: data.watchlistTvs.length,
                          );
                        } else {
                          return Center(
                            key: const Key('error_message'),
                            child: Text(data.message),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
