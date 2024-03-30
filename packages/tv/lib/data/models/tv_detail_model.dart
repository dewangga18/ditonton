import 'package:core/model/genre_model.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';

class TvDetailResponse extends Equatable {
  final bool? adult;
  final String? backdropPath;
  final String? firstAirDate;
  final List<GenreModel>? genres;
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

  const TvDetailResponse({
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

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        firstAirDate: json["first_air_date"],
        genres: json["genres"] == null
            ? []
            : List<GenreModel>.from(
                json["genres"]!.map((x) => GenreModel.fromJson(x)),
              ),
        homepage: json["homepage"],
        id: json["id"],
        inProduction: json["in_production"],
        languages: json["languages"] == null
            ? []
            : List<String>.from(json["languages"]!.map((x) => x)),
        lastAirDate: json["last_air_date"],
        name: json["name"],
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        originCountry: json["origin_country"] == null
            ? []
            : List<String>.from(json["origin_country"]!.map((x) => x)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        status: json["status"],
        tagline: json["tagline"],
        type: json["type"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "first_air_date": firstAirDate,
        "genres": genres == null
            ? []
            : List<dynamic>.from(genres!.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "in_production": inProduction,
        "languages": languages == null
            ? []
            : List<dynamic>.from(languages!.map((x) => x)),
        "last_air_date": lastAirDate,
        "name": name,
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "origin_country": originCountry == null
            ? []
            : List<dynamic>.from(originCountry!.map((x) => x)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "status": status,
        "tagline": tagline,
        "type": type,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  TvDetail toEntity() {
    return TvDetail(
      adult: adult,
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      id: id,
      homepage: homepage,
      inProduction: inProduction,
      languages: languages,
      genres: genres?.map((genre) => genre.toEntity()).toList(),
      lastAirDate: lastAirDate,
      name: name,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      status: status,
      tagline: tagline,
      type: type,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

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
