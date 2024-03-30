import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:popular/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';

class PopularPage extends StatelessWidget {
  const PopularPage({
    super.key,
    required this.index,
  });

  final int index;
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (index == 0) {
      child = BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
        builder: (context, state) {
          if (state is PopularMoviesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularMoviesHasData) {
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
          } else if (state is PopularMoviesError) {
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
      child = BlocBuilder<PopularTvBloc, PopularTvState>(
        builder: (context, state) {
          if (state is PopularTvLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularTvHasData) {
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
          } else if (state is PopularTvError) {
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
          index == 0 ? 'Popular Movies' : 'Popular Tvs',
        ),
      ),
      body: child,
    );
  }
}
