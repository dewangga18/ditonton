import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/list/movie_list_bloc.dart';
import 'package:core/widgets/space_x.dart';
import 'package:flutter/material.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:popular/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:top_rated/presentation/bloc/movie/top_rated_movie_bloc.dart';

class MovieSection extends StatelessWidget {
  const MovieSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movie Area',
              style: kHeading5,
            ),
            15.verticalSpace,
            _buildSubHeading(
              title: 'Now PLaying',
              onTap: () => Navigator.pushNamed(
                context,
                MOVIE_NOW_PLAYING_ROUTE,
              ),
            ),
            BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, state) {
                if (state is MovieListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MovieListHasData) {
                  return MovieList(movies: state.result);
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
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(
                context,
                POPULAR_ROUTE,
                arguments: 0,
              ),
            ),
            BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
              builder: (context, state) {
                if (state is PopularMoviesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularMoviesHasData) {
                  return MovieList(movies: state.result);
                } else if (state is PopularMoviesError) {
                  return Center(
                    key: const Key('error_message'),
                    child: Text(state.error.message),
                  );
                } else {
                  return Container();
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(
                context,
                TOP_RATED_ROUTE,
                arguments: 0,
              ),
            ),
            BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
              builder: (context, state) {
                if (state is TopRatedMovieLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedMovieHasData) {
                  return MovieList(movies: state.result);
                } else if (state is TopRatedMovieError) {
                  return Center(
                    key: const Key('error_message'),
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
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MOVIE_DETAIL_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath ?? ''}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
