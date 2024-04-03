import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_bloc.dart';

class CardList extends StatelessWidget {
  final Movie? movie;
  final Tv? tv;

  const CardList({
    super.key,
    this.movie,
    this.tv,
  });

  @override
  Widget build(BuildContext context) {
    if (movie != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              MOVIE_DETAIL_ROUTE,
              arguments: movie?.id,
            ).then((_) {
              context.read<WatchlistMovieBloc>().add(FetchWatchlistMovie());
            });
          },
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Card(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 16 + 80 + 16,
                    bottom: 8,
                    right: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie?.title ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        movie?.overview ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (movie?.posterPath == null) ...[
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    bottom: 16,
                  ),
                  child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: SizedBox(
                      width: 80,
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    bottom: 16,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: '$baseImageUrl${movie?.posterPath ?? ''}',
                      width: 80,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (_, url, e) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    } else if (tv != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              TV_DETAIL_ROUTE,
              arguments: tv?.id,
            ).then((_) {
              context.read<WatchlistTvBloc>().add(FetchWatchlistTv());
            });
          },
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Card(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 16 + 80 + 16,
                    bottom: 8,
                    right: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tv?.name ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tv?.overview ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (tv?.posterPath == null) ...[
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    bottom: 16,
                  ),
                  child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: SizedBox(
                      width: 80,
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    bottom: 16,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: '$baseImageUrl${tv?.posterPath ?? ''}',
                      width: 80,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (_, url, e) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
