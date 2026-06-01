import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gauge/app/modules/theme/model/gauge_theme.dart';
import 'package:gauge/app/core/values/constants.dart';

class GaugeThemeProvider extends GetConnect {
  final box = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = BaseApiUrl;
    httpClient.addRequestModifier<dynamic>((request) {
      final token = box.read('token');

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }

  Future<GaugeThemeResponse> getThemes({required int page, required String sort, required String search}) async {
    final response = await get('/themes', query: {'page': page.toString(), 'sort': sort, 'search': search});
    if (response.statusCode == 200) return GaugeThemeResponse.fromJson(response.body);
    throw Exception('Błąd pobierania: ${response.statusCode}');
  }

  Future<GaugeThemeResponse> getMyThemes({required int page, required String sort, required String search}) async {
    final response = await get('/my-themes', query: {'page': page.toString(), 'sort': sort, 'search': search});
    if (response.status.hasError) {
      throw Exception('Błąd: ${response.statusCode}');
    }
    if (response.statusCode == 200) return GaugeThemeResponse.fromJson(response.body);
    throw Exception('Błąd pobierania moich motywów: ${response.statusCode}');
  }

  Future<bool> sendToggleLike(int id) async {
    final response = await post('/themes/$id/like', {});
    return response.statusCode == 200;
  }
}

class GaugeThemeResponse {
  final List<GaugeTheme> themes;
  final int currentPage;
  final bool hasMore;

  GaugeThemeResponse({required this.themes, required this.currentPage, required this.hasMore});

  factory GaugeThemeResponse.fromJson(Map<String, dynamic> json) {
    // API zwraca: {"themes": {"data": [...], "meta": {...}, "links": {...}}}
    final themesWrapper = json['themes'] as Map<String, dynamic>? ?? {};
    final List<dynamic> data = themesWrapper['data'] is List ? themesWrapper['data'] : [];

    final meta = themesWrapper['meta'] as Map<String, dynamic>?;
    final links = themesWrapper['links'] as Map<String, dynamic>?;

    return GaugeThemeResponse(
      themes: data.map((i) => GaugeTheme.fromJson(i)).toList(),
      currentPage: meta?['current_page'] ?? themesWrapper['current_page'] ?? 1,
      hasMore: (links?['next'] != null) || (themesWrapper['next_page_url'] != null),
    );
  }
}