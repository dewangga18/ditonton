import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/entity/genre.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/detail/movie_detail_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;

  const MovieDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
    context.read<MovieDetailBloc>().add(FetchMovieRecommendation(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.data != null) {
            return SafeArea(
              child: DetailContent(
                movie: state.data!,
                recommendations: state.dataRecomendation ?? [],
                isAddedWatchlist: state.isWatchlist,
              ),
            );
          } else if (state.error != null) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.error!.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent({
    super.key,
    required this.movie,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return DraggableContent(
                scrollController: scrollController,
                movie: movie,
                isAddedWatchlist: isAddedWatchlist,
                recommendations: recommendations,
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}

class DraggableContent extends StatelessWidget {
  const DraggableContent({
    super.key,
    required this.scrollController,
    required this.movie,
    required this.isAddedWatchlist,
    required this.recommendations,
  });

  final ScrollController scrollController;
  final MovieDetail movie;
  final bool isAddedWatchlist;
  final List<Movie> recommendations;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kRichBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
      ),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: kHeading5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!isAddedWatchlist) {
                        context
                            .read<MovieDetailBloc>()
                            .add(AddMovieWatchlist(movie));
                      } else {
                        context
                            .read<MovieDetailBloc>()
                            .add(DeleteMovieWatchlist(movie));
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isAddedWatchlist
                            ? const Icon(Icons.check)
                            : const Icon(Icons.add),
                        const Text('Watchlist'),
                      ],
                    ),
                  ),
                  Text(
                    _showGenres(movie.genres),
                  ),
                  Text(
                    _showDuration(movie.runtime),
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: movie.voteAverage / 2,
                        itemCount: 5,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: kMikadoYellow,
                        ),
                        itemSize: 24,
                      ),
                      Text('${movie.voteAverage}')
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Overview',
                    style: kHeading6,
                  ),
                  Text(
                    movie.overview,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recommendations',
                    style: kHeading6,
                  ),
                  BlocBuilder<MovieDetailBloc, MovieDetailState>(
                    builder: (context, state) {
                      if (state.isLoadingRecommendation) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.errorRecommendation != null) {
                        return Text(
                          state.errorRecommendation?.message ?? '-',
                        );
                      } else if (state.dataRecomendation != null) {
                        return SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final movie = recommendations[index];

                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      MOVIE_DETAIL_ROUTE,
                                      arguments: movie.id,
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '$baseImageUrl${movie.posterPath ?? ''}',
                                      placeholder: (_, __) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (_, url, er) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: recommendations.length,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white,
              height: 4,
              width: 48,
            ),
          ),
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
