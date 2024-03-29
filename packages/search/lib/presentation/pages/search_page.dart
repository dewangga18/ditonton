import 'package:core/core.dart';
import 'package:core/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/provider/movie_search_notifier.dart';
import 'package:search/presentation/provider/tv_search_notifier.dart';

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
                onSubmitted: (query) {
                  Provider.of<MovieSearchNotifier>(
                    context,
                    listen: false,
                  ).fetchMovieSearch(query);
                  Provider.of<TvSearchNotifier>(
                    context,
                    listen: false,
                  ).fetchTvSearch(query);
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
                    Consumer<MovieSearchNotifier>(
                      builder: (context, data, child) {
                        if (data.state == RequestState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (data.state == RequestState.loaded) {
                          final result = data.searchResult;
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = data.searchResult[index];
                              return CardList(movie: movie);
                            },
                            itemCount: result.length,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Consumer<TvSearchNotifier>(
                      builder: (context, data, child) {
                        if (data.state == RequestState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (data.state == RequestState.loaded) {
                          final result = data.searchResult;
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final tv = data.searchResult[index];
                              return CardList(tv: tv);
                            },
                            itemCount: result.length,
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
