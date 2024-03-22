import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movies/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/tvs/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedPage extends StatefulWidget {
  static const routeName = '/top-rated';

  const TopRatedPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<TopRatedPage> createState() => _TopRatedPageState();
}

class _TopRatedPageState extends State<TopRatedPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.index == 0) {
        Provider.of<TopRatedMoviesNotifier>(
          context,
          listen: false,
        ).fetchTopRatedMovies();
      } else {
        Provider.of<TopRatedTvsNotifier>(
          context,
          listen: false,
        ).fetchTopRatedTvs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.index == 0) {
      child = Consumer<TopRatedMoviesNotifier>(
        builder: (context, data, child) {
          if (data.state == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.state == RequestState.loaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final movie = data.movies[index];
                return CardList(movie: movie);
              },
              itemCount: data.movies.length,
            );
          } else {
            return Center(
              key: const Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      );
    } else {
      child = Consumer<TopRatedTvsNotifier>(
        builder: (context, data, child) {
          if (data.state == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.state == RequestState.loaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final tv = data.tvs[index];
                return CardList(tv: tv);
              },
              itemCount: data.tvs.length,
            );
          } else {
            return Center(
              key: const Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.index == 0 ? 'Top Rated Movies' : 'Top Rated Tvs',
        ),
      ),
      body: child,
    );
  }
}
