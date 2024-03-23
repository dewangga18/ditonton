import 'package:dartz/dartz.dart';
import '../entities/movie_detail.dart';
import '../repository/movie_repository.dart';
import 'package:core/utils/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
