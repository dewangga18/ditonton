import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/repository/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
