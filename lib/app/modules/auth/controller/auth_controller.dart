import 'package:flutter/material.dart';
import 'package:gauge/app/core/values/constants.dart';
import 'package:gauge/app/modules/auth/model/user.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final GetConnect _connect = GetConnect();
  final box = GetStorage();

  // Kontrolery pól
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Stany UI
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Przełączanie widoczności hasła
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Logowanie
  Future<void> logout() async {
    try {
      final response = await _connect.post(
        '$BaseApiUrl/logout', {}
      );

      if (response.statusCode == 200) {
        final body = response.body;

          box.write('token', null);
          box.write('user', null);

        // Przejście do aplikacji
        Get.offNamed(Routes.deviceSelect);
      } else {
        // Obsługa błędów API (np. błędne hasło)
        final String errorMessage = response.body?['message'] ?? '';
        Get.snackbar("Błąd wylogowania", errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Błąd", "Problem z połączeniem z serwerem", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Błąd",
        "Wypełnij wszystkie pola",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _connect.post(
        '$BaseApiUrl/login',
        {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;

        // Zapisujemy token (Bearer)
        if (body['token'] != null) {
          box.write('token', body['token']);
        }

        // Zapisujemy dane użytkownika
        if (body['user'] != null) {
          box.write('user', User.fromJson(body['user']));
        }

        // Przejście do aplikacji
        Get.offNamed(Routes.themes);
      } else {
        // Obsługa błędów API (np. błędne hasło)
        final String errorMessage = response.body?['message'] ?? 'Nieprawidłowe dane logowania';
        Get.snackbar("Błąd logowania", errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Błąd", "Problem z połączeniem z serwerem", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  User getUser(){
    if(box.read('user') == null)
    {
      return User(id: -1, name:"", );
    }
    return  box.read('user');
  }

  bool isLoggedIn(){
    return  box.hasData('token');
  }

}