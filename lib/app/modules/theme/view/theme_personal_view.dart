import 'package:flutter/material.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';
import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:gauge/app/modules/theme/view/theme_public_view.dart';
import 'package:gauge/app/modules/theme/widgets/theme_list.dart';
import 'package:gauge/app/modules/theme/widgets/theme_sort_header_widget.dart'; // Import nowego pliku
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ThemePersonalView extends StatelessWidget {
  ThemePersonalView({super.key});

  final ThemeController controller = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const title = 'Moje motywy';

    return AppLayout(
      title: title,
      appbar: AppBar(
        title: const Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      content: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                ThemeSortHeaderWidget(), // Wywołanie wydzielonego widżetu również tutaj
                Expanded(
                  child: ThemeListWidget(),
                ),
              ],
            ),
          ),

          // Dolny nawigator zakładek
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.dividerColor),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      context,
                      'Wszystkie',
                      isSelected: false,
                      onTap: () {
                        controller.showAllThemes();
                        Get.offNamed(Routes.themes);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTabButton(
                      context,
                      'Moje motywy',
                      isSelected: true,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String label, {required bool isSelected, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}