import 'dart:convert';
import 'dart:developer';

import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const apiKey = 'api_key=d4f7c3f6fafd319bdd1280efe4526d28';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    var url = Uri.parse('$baseUrl/movie/now_playing?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var url = Uri.parse('$baseUrl/movie/$id?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    var url = Uri.parse('$baseUrl/movie/$id/recommendations?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    var url = Uri.parse('$baseUrl/movie/popular?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    var url = Uri.parse('$baseUrl/movie/top_rated?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    var url = Uri.parse('$baseUrl/search/movie?$apiKey&query=$query');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
}
