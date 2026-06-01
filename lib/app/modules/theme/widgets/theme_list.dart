import 'package:flutter/material.dart';
import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:gauge/app/modules/theme/widgets/theme_tile.dart';
import 'theme_sort_header_widget.dart';
import 'package:get/get.dart';

class ThemeListWidget extends StatelessWidget {
  const ThemeListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<ThemeController>(
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: () {
                if (controller.isLoading && controller.themes.isEmpty) {
                  return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                }

                if (controller.errorMessage != null && controller.themes.isEmpty) {
                  return _buildRefreshWrapper(
                    context,
                    controller,
                    Text(
                      controller.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  );
                }

                if (controller.themes.isEmpty) {
                  return _buildRefreshWrapper(
                    context,
                    controller,
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: theme.hintColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Brak motywów spełniających kryteria',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }


                return RefreshIndicator(
                  color: theme.colorScheme.primary,
                  onRefresh: () => controller.fetchThemes(refresh: true),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.74,
                          ),
                          itemCount: controller.themes.length,
                          itemBuilder: (context, index) {
                            final item = controller.themes[index];
                            return ThemeTileWidget(
                              key: ValueKey(item.id),
                              themeItem: item,
                            );
                          },
                        ),
                      ),


                      if (controller.isLoadingMore)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                              strokeWidth: 3,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }(),
            ),
          ],
        );
      },
    );
  }


  Widget _buildRefreshWrapper(BuildContext context, ThemeController controller, Widget child) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchThemes(refresh: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,

          child: Align(
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
      ),
    );
  }
}