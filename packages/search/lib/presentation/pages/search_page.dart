import 'package:core/core.dart';
import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/bloc/movie/movie_search_bloc.dart';
import 'package:search/bloc/tv/tv_search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (query) {
                  context.read<MovieSearchBloc>().add(MovieOnQueryChanged(query));
                  context.read<TvSearchBloc>().add(TvOnQueryChanged(query));
                },
                decoration: const InputDecoration(
                  hintText: 'Search title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 16),
              Text(
                'Search Result',
                style: kHeading6,
              ),
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
                    BlocBuilder<MovieSearchBloc, MovieSearchState>(
                      builder: (context, state) {
                        if (state is MovieSearchLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is MovieSearchHasData) {
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
                        } else if (state is MovieSearchError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    BlocBuilder<TvSearchBloc, TvSearchState>(
                      builder: (context, state) {
                        if (state is TvSearchLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TvSearchHasData) {
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
                        } else if (state is TvSearchError) {
                          return Center(
                            child: Text(state.message),
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
