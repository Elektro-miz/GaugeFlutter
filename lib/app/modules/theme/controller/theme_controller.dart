import 'package:flutter/material.dart';
import 'package:gauge/app/modules/auth/controller/auth_controller.dart';
import 'package:gauge/app/modules/auth/model/user.dart';
import 'package:get/get.dart';
import 'package:gauge/app/modules/theme/model/gauge_theme.dart';
import 'package:gauge/app/modules/theme/provider/gauge_theme_provider.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GaugeThemeProvider _apiProvider = Get.put(GaugeThemeProvider());
  final AuthController authController = Get.find();

  // Listy danych
  List<GaugeTheme> themes = [];
  final box = GetStorage();

  // Statusy UI
  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;

  // Paginacja i stan
  final scrollController = ScrollController();
  int _page = 1;
  bool _hasMore = true;
  bool isPersonalTab = false; // Zmienione na publiczne, żeby widok mógł to sprawdzić

  // Filtry
  String searchQuery = '';
  String selectedSort = 'Najpopularniejsze';
  final List<String> sortOptions = ['Najpopularniejsze', 'Alfabetycznie', 'Polubienia'];
  bool isAscending = false;

  @override
  void onInit() {
    super.onInit();
    fetchThemes(refresh: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!isLoading && !isLoadingMore && _hasMore) {
          fetchThemes(refresh: false);
        }
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    fetchThemes(refresh: true);
  }

  void showAllThemes() {
    if (isPersonalTab) {
      isPersonalTab = false;
      fetchThemes(refresh: true);
    }
  }

  void showPersonalThemes() {
    if (!isPersonalTab) {
      isPersonalTab = true;
      fetchThemes(refresh: true);
    }
  }

  void changeSort(String? value) {
    if (value != null && value != selectedSort) {
      selectedSort = value;
      fetchThemes(refresh: true);
    }
  }

  void toggleSortOrder() {
    isAscending = !isAscending;
    fetchThemes(refresh: true);
  }

  String _mapSortToLaravel() {
    final String direction = isAscending ? 'asc' : 'desc';
    switch (selectedSort) {
      case 'Alfabetycznie': return 'name_$direction';
      case 'Polubienia': return 'likes_$direction';
      case 'Najpopularniejsze': default: return 'downloads_$direction';
    }
  }

  Future<void> fetchThemes({bool refresh = false}) async {
    if (refresh) {
      themes = [];
      _page = 1;
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    if (refresh) {
      isLoading = true;
      errorMessage = null;
    } else {
      isLoadingMore = true;
    }
    update();

    try {
      GaugeThemeResponse apiResponse;

      if (isPersonalTab) {
        apiResponse = await _apiProvider.getMyThemes(
          page: _page,
          sort: _mapSortToLaravel(),
          search: searchQuery,
        );
      } else {
        apiResponse = await _apiProvider.getThemes(
          page: _page,
          sort: _mapSortToLaravel(),
          search: searchQuery,
        );
      }

      _hasMore = apiResponse.hasMore;

      if (refresh) {
        themes = List.from(apiResponse.themes);
      } else {
        themes.addAll(apiResponse.themes);
      }

      _page = apiResponse.currentPage + 1;

      isLoading = false;
      isLoadingMore = false;
      update();

    } catch (e) {
      errorMessage = 'Błąd: $e';
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  void toggleLike(int id) async {
    final index = themes.indexWhere((theme) => theme.id == id);
    if (index == -1) return;

    final oldTheme = themes[index];
    final newIsLiked = !oldTheme.isLiked;

    // Optymistyczna aktualizacja
    themes[index] = oldTheme.copyWith(
      isLiked: newIsLiked,
      likesCount: newIsLiked ? oldTheme.likesCount + 1 : oldTheme.likesCount - 1,
    );
    update();

    try {
      bool success = await _apiProvider.sendToggleLike(id);
      if (!success) throw Exception();
    } catch (e) {
      themes[index] = oldTheme;
      update();
      Get.snackbar('Błąd', 'Nie udało się zapisać polubienia.');
    }
  }

  int get currentUserId {
    return authController.getUser().id;
  }
}