import 'package:top_rated/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:top_rated/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:core/widgets/card_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TopRatedPage extends StatelessWidget {
  const TopRatedPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (index == 0) {
      child = BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
        builder: (context, state) {
          if (state is TopRatedMovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopRatedMovieHasData) {
            final result = state.result;

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = result[index];

                return CardList(movie: movie);
              },
              itemCount: result.length,
            );
          } else if (state is TopRatedMovieError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.error.message),
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      child = BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
        builder: (context, state) {
          if (state is TopRatedTvLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopRatedTvHasData) {
            final result = state.result;

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tv = result[index];

                return CardList(tv: tv);
              },
              itemCount: result.length,
            );
          } else if (state is TopRatedTvError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.error.message),
            );
          } else {
            return Container();
          }
        },
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          index == 0 ? 'Top Rated Movies' : 'Top Rated Tvs',
        ),
      ),
      body: child,
    );
  }
}
