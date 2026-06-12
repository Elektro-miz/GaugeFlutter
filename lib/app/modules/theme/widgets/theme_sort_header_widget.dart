import 'package:flutter/material.dart';
import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:gauge/app/global_widgets/layouts/app/responsive_layout.dart';

class ThemeSortHeaderWidget extends StatelessWidget {
  final bool isPersonal;

  const ThemeSortHeaderWidget({
    super.key,
    required this.isPersonal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = context.isDesktop || context.isDeviceLandscape;

    return Material(
      color: Colors.transparent,
      child: GetBuilder<ThemeController>(
        builder: (controller) {
          // --- SUWAK Z IKONAMI (PO LEWEJ STRONIE) ---
          Widget viewToggle = Container(
            height: 38,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.dividerColor, width: 1),
            ),
            child: ToggleButtons(
              isSelected: [
                !isPersonal,
                isPersonal,
              ],
              onPressed: (index) {
                if (index == 0 && isPersonal) {
                  Get.offNamed(Routes.themes);
                } else if (index == 1 && !isPersonal) {
                  Get.offNamed(Routes.myThemes);
                }
              },
              borderRadius: BorderRadius.circular(8),
              renderBorder: false,
              fillColor: theme.colorScheme.primary,
              selectedColor: theme.colorScheme.onPrimary,
              color: theme.colorScheme.onSurfaceVariant,
              constraints: const BoxConstraints(minWidth: 46, minHeight: 32),
              children: const [
                Tooltip(
                  message: 'Wszystkie motywy',
                  child: Icon(Icons.public_rounded, size: 20),
                ),
                Tooltip(
                  message: 'Moje motywy',
                  child: Icon(Icons.person_rounded, size: 20),
                ),
              ],
            ),
          );

          // --- SEKCJA SORTOWANIA (Z PRZYWRÓCONYMI LABELAMI) ---
          Widget sortSection = Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Label + Dropdown do sortowania
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sortuj:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.dividerColor, width: 1.2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedSort,
                          dropdownColor: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          icon: const SizedBox.shrink(),
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          onChanged: controller.changeSort,
                          items: controller.sortOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(option),
                                  const SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.primary, size: 16),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                // 2. Label + Przycisk kierunku sortowania
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Kolejność:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: OutlinedButton(
                        onPressed: controller.toggleSortOrder,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: theme.dividerColor, width: 1.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Icon(
                          controller.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          // --- POLE WYSZUKIWANIA ---
          Widget searchField = TextField(
            onChanged: controller.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Szukaj motywu...',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              fillColor: theme.cardColor,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          // Budowanie układu zależnie od szerokości ekranu
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: isWide
                ? Row(
                    children: [
                      viewToggle, // Na szerokim ekranie suwak na początku linii
                      const SizedBox(width: 12),
                      Expanded(flex: 4, child: searchField),
                      const SizedBox(width: 12),
                      Expanded(flex: 5, child: sortSection),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          viewToggle, // W pionie suwak ląduje obok pola wyszukiwania
                          const SizedBox(width: 10),
                          Expanded(child: searchField),
                        ],
                      ),
                      const SizedBox(height: 10),
                      sortSection,
                    ],
                  ),
          );
        },
      ),
    );
  }
}