// ignore: depend_on_referenced_packages
import 'package:mockito/annotations.dart';
import 'package:movie/domain/repository/movie_repository.dart';
import 'package:http/http.dart' as http;
import 'package:tv/domain/repository/tv_repository.dart';

@GenerateMocks([
  MovieRepository,
  TvRepository,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
