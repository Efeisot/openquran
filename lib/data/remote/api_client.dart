import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

@riverpod
ApiClient apiClient(Ref ref) => ApiClient();

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.acikkuran.com'));

  Future<List<dynamic>> getSurahs() async {
    final response = await _dio.get('/surahs');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getSurah(int id, {int? authorId}) async {
    final response = await _dio.get(
      '/surah/$id',
      queryParameters: {if (authorId != null) 'author': authorId},
    );
    return response.data['data'];
  }

  Future<List<dynamic>> getAuthors() async {
    final response = await _dio.get('/authors');
    return response.data['data'];
  }

  Future<List<dynamic>> getVerseTranslations(
    int surahId,
    int verseNumber,
  ) async {
    final response = await _dio.get(
      '/surah/$surahId/verse/$verseNumber/translations',
    );
    return response.data['data'];
  }

  Future<List<dynamic>> getVerseWords(int surahId, int verseNumber) async {
    final response = await _dio.get(
      '/surah/$surahId/verse/$verseNumber/verseparts',
    );
    return response.data['data'];
  }
}
