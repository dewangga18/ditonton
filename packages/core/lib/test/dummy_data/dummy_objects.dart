import 'package:movie/data/models/movie_table.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:core/entity/genre.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

const testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

const testTv = Tv(
  adult: false,
  backdropPath: '/3oZgE4220UrqaaiZXxz5MtNCVxJ.jpg',
  id: 12513,
  name: 'Operación Triunfo',
  originalLanguage: 'es',
  originalName: 'Operación Triunfo',
  overview:
      'Reality-show talent contest aimed to find the country\'s next solo singing sensation, putting a selection of hopefuls through their paces by getting them to sing a variety of cover versions of popular songs, with tutoring from various professionals.',
  popularity: 2092.564,
  posterPath: '/8Qfq22zP5PeUKJfN5bFPFJtJz5i.jpg',
  voteAverage: 6.389,
  voteCount: 18,
);

final testMovieList = [testMovie];

final testTvList = [testTv];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

const testTvDetail = TvDetail(
  adult: false,
  backdropPath: '/3oZgE4220UrqaaiZXxz5MtNCVxJ.jpg',
  genres: [Genre(id: 10764, name: 'Reality')],
  homepage: '',
  id: 12513,
  inProduction: true,
  name: 'Operación Triunfo',
  numberOfEpisodes: 248,
  numberOfSeasons: 12,
  originalLanguage: 'es',
  originalName: 'Operación Triunfo',
  overview:
      'Reality-show talent contest aimed to find the country\'s next solo singing sensation, putting a selection of hopefuls through their paces by getting them to sing a variety of cover versions of popular songs, with tutoring from various professionals.',
  popularity: 2092.564,
  posterPath: '/8Qfq22zP5PeUKJfN5bFPFJtJz5i.jpg',
  status: 'Returning Series',
  tagline: '',
  type: 'Reality',
  voteAverage: 6.389,
  voteCount: 18,
);

const testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testWatchlistTv = Tv.watchlist(
  id: 12513,
  name: 'Operación Triunfo',
  overview:
      'Reality-show talent contest aimed to find the country\'s next solo singing sensation, putting a selection of hopefuls through their paces by getting them to sing a variety of cover versions of popular songs, with tutoring from various professionals.',
  posterPath: '/8Qfq22zP5PeUKJfN5bFPFJtJz5i.jpg',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvTable = TvTable(
  id: 12513,
  name: 'Operación Triunfo',
  overview:
      'Reality-show talent contest aimed to find the country\'s next solo singing sensation, putting a selection of hopefuls through their paces by getting them to sing a variety of cover versions of popular songs, with tutoring from various professionals.',
  posterPath: '/8Qfq22zP5PeUKJfN5bFPFJtJz5i.jpg',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvMap = {
  'id': 12513,
  'overview':
      'Reality-show talent contest aimed to find the country\'s next solo singing sensation, putting a selection of hopefuls through their paces by getting them to sing a variety of cover versions of popular songs, with tutoring from various professionals.',
  'posterPath': '/8Qfq22zP5PeUKJfN5bFPFJtJz5i.jpg',
  'name': 'Operación Triunfo',
};
