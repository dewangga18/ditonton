import 'package:movie/domain/repository/movie_repository.dart';

class GetWatchListMovieStatus {
  final MovieRepository repository;

  GetWatchListMovieStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToMovieWatchlist(id);
  }
}
