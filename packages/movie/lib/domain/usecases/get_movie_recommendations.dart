import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/movie.dart';
import '../repository/movie_repository.dart';
import 'package:core/utils/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
