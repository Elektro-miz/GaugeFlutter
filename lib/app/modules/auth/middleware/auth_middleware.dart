import 'package:flutter/material.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    bool isLoggedIn = box.hasData('token');

    // 1. Jeśli użytkownik nie jest zalogowany, a trasa to NIE logowanie
    if (!isLoggedIn && route != Routes.auth) {
      return const RouteSettings(name: Routes.auth);
    }

    // 2. Jeśli użytkownik JEST zalogowany, a trasa to logowanie
    if (isLoggedIn && route == Routes.auth) {
      return const RouteSettings(name: AppPages.initial);
    }

    return null;
  }
}