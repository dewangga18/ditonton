import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/list/movie_list_bloc.dart';

class MovieNowPlayingPage extends StatelessWidget {
  const MovieNowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Now Playing',
        ),
      ),
      body: BlocBuilder<MovieListBloc, MovieListState>(
        builder: (context, state) {
          if (state is MovieListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieListHasData) {
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
          } else if (state is MovieListError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.error.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
