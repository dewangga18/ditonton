import 'package:core/utils/state_enum.dart';
import 'package:movie/presentation/providers/popular_movies_notifier.dart';
import 'package:tv/presentation/providers/popular_tv_notifier.dart';
import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.index == 0) {
      Provider.of<PopularMoviesNotifier>(
        context,
        listen: false,
      ).fetchPopularMovies();
      } else {
      Provider.of<PopularTvsNotifier>(
        context,
        listen: false,
      ).fetchPopularTvs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.index == 0) {
      child = Consumer<PopularMoviesNotifier>(
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
      child = Consumer<PopularTvsNotifier>(
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
          widget.index == 0 ? 'Popular Movies' : 'Popular Tvs',
        ),
      ),
      body: child,
    );
  }
}
