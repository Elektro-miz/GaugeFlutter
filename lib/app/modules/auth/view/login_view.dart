import 'package:flutter/material.dart';
import 'package:gauge/app/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AuthController controller = Get.find<AuthController>();
    const title = 'Logowanie';

    return AppLayout(
      title: title,
      content: Center(
        // Blokujemy rozciąganie formularza na Desktopie i w Landscape
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AutofillGroup(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.login_rounded, size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 24),
                  Text(
                    "Logowanie",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 48),

                  // Pole Email
                  TextField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 16),

                  // Pole Hasło
                  Obx(() => TextField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Hasło',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    obscureText: controller.isPasswordHidden.value,
                    autofillHints: const [AutofillHints.password],
                  )),
                  const SizedBox(height: 32),

                  // Przycisk
                  SizedBox(
                    height: 56,
                    child: Obx(() => FilledButton(
                      onPressed: controller.isLoading.value ? null : () => controller.login(),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          : const Text('Zaloguj się', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}