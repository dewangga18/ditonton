import 'dart:convert';
import 'dart:developer';

import 'package:core/utils/exception.dart';
import 'package:http/http.dart' as http;
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_response.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getNowPlayingTvs();
  Future<List<TvModel>> getPopularTvs();
  Future<List<TvModel>> getTopRatedTvs();
  Future<TvDetailResponse> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTvs(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static const apiKey = 'api_key=d4f7c3f6fafd319bdd1280efe4526d28';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getNowPlayingTvs() async {
    var url = Uri.parse('$baseUrl/tv/on_the_air?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    var url = Uri.parse('$baseUrl/tv/$id?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    var url = Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvs() async {
    var url = Uri.parse('$baseUrl/tv/popular?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvs() async {
    var url = Uri.parse('$baseUrl/tv/top_rated?$apiKey');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvs(String query) async {
    var url = Uri.parse('$baseUrl/search/tv?$apiKey&query=$query');
    log(url.toString());
    final response = await client.get(url);
    log(response.body);

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
