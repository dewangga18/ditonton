import 'package:core/entity/genre.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final bool? adult;
  final String? backdropPath;
  final String? firstAirDate;
  final List<Genre>? genres;
  final String? homepage;
  final int id;
  final bool? inProduction;
  final List<String>? languages;
  final String? lastAirDate;
  final String? name;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? status;
  final String? tagline;
  final String? type;
  final double? voteAverage;
  final int? voteCount;

  const TvDetail({
    this.adult,
    this.backdropPath,
    this.firstAirDate,
    this.genres,
    this.homepage,
    required this.id,
    this.inProduction,
    this.languages,
    this.lastAirDate,
    this.name,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.originCountry,
    this.originalLanguage,
    this.originalName,
    this.overview,
    this.popularity,
    this.posterPath,
    this.status,
    this.tagline,
    this.type,
    this.voteAverage,
    this.voteCount,
  });

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAirDate,
        genres,
        homepage,
        id,
        inProduction,
        languages,
        lastAirDate,
        name,
        numberOfEpisodes,
        numberOfSeasons,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        status,
        tagline,
        type,
        voteAverage,
        voteCount,
      ];
}
