import 'dart:convert';

import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:core/utils/exception.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:core/test/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = 'api_key=d4f7c3f6fafd319bdd1280efe4526d28';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Tv', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_now_playing.json')),
    ).tvList;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_now_playing.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getNowPlayingTvs();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Found',
            404,
          ),
        );
        // act
        final call = dataSource.getNowPlayingTvs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Tvs', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_popular.json')),
    ).tvList;

    test(
      'should return list of tvs when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_popular.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getPopularTvs();
        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Found',
            404,
          ),
        );
        // act
        final call = dataSource.getPopularTvs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Tvs', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated.json')),
    ).tvList;

    test(
      'should return list of tvs when response code is 200 ',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/top_rated.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTopRatedTvs();
        // assert
        expect(result, tTvList);
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Found',
            404,
          ),
        );
        // act
        final call = dataSource.getTopRatedTvs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv detail', () {
    const tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test(
      'should return tv detail when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_detail.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvDetail(tId);
        // assert
        expect(result, equals(tTvDetail));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Found',
            404,
          ),
        );
        // act
        final call = dataSource.getTvDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;
    const tId = 1;

    test('should return list of Tv Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
      )).thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_recommendations.json'), 200));
      // act
      final result = await dataSource.getTvRecommendations(tId);
      // assert
      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv', () {
    final tSearchResult = TvResponse.fromJson(
      json.decode(readJson('dummy_data/search_doraemon_tv.json')),
    ).tvList;
    const tQuery = 'Doraemon';

    test(
      'should return list of tv when response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
        )).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/search_doraemon_tv.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.searchTvs(tQuery);
        // assert
        expect(result, tSearchResult);
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTvs(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
