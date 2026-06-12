import 'package:flutter/material.dart';
import 'package:gauge/app/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';

class LogoutView extends StatelessWidget {
  const LogoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AuthController controller = Get.find<AuthController>();

    // Pobranie nazwy użytkownika bezpośrednio z kontrolera
    final String username = controller.getUser().name;
    const title = 'Profil';

    return AppLayout(
      title: title,
      content: Center(
        // Trzymamy szerokość profilu w ryzach na szerokich ekranach
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ikona profilu
                Icon(Icons.account_circle_rounded, size: 80, color: theme.colorScheme.primary),
                const SizedBox(height: 24),

                // Napis: Zalogowano jako [nazwa_użytkownika]
                Text(
                  "Zalogowano jako:\n$username",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 48),

                // Przycisk Wyloguj
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                    ),
                    onPressed: () => _showLogoutConfirmationDialog(context, controller),
                    child: const Text(
                      'Wyloguj się',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Okno dialogowe z pytaniem Tak/Nie
  void _showLogoutConfirmationDialog(BuildContext context, AuthController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Wylogowanie'),
        content: const Text('Czy na pewno chcesz się wylogować?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Nie'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              'Tak',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}