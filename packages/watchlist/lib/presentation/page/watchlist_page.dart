import 'package:core/core.dart';
import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/tv/watchlist_tv_bloc.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

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
                    BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
                      builder: (context, state) {
                        if (state is WatchlistMovieLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WatchlistMovieHasData) {
                          final result = state.result;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final movie = result[index];
                          
                              return CardList(movie: movie);
                            },
                            itemCount: result.length,
                          );
                        } else if (state is WatchlistMovieError) {
                          return Center(
                            child: Text(state.error.message),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
                      builder: (context, state) {
                        if (state is WatchlistTvLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is WatchlistTvHasData) {
                          final result = state.result;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final tv = result[index];
                          
                              return CardList(tv: tv);
                            },
                            itemCount: result.length,
                          );
                        } else if (state is WatchlistTvError) {
                          return Center(
                            child: Text(state.error.message),
                          );
                        } else {
                          return Container();
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
}
