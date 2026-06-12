import 'package:flutter/material.dart';
import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:gauge/app/modules/theme/widgets/theme_tile.dart';
import 'package:gauge/app/modules/theme/widgets/theme_sort_header_widget.dart';
import 'package:get/get.dart';
import 'package:gauge/app/global_widgets/layouts/app/responsive_layout.dart';

class ThemeListWidget extends StatelessWidget {
  final bool isPersonalView;

  const ThemeListWidget({
    super.key,
    required this.isPersonalView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    int getCrossAxisCount() {
      if (context.isDesktop) return 4;
      if (context.isDeviceLandscape) return 3;
      return 2;
    }

    double getChildAspectRatio() {
      if (context.isDesktop) return 0.74;
      if (context.isDeviceLandscape) {
        final availableHeight = screenHeight - 60 - 45;
        final availableWidth = (screenWidth - 32 - (2 * 12)) / 3;
        return (availableWidth / (availableHeight > 0 ? availableHeight : 150)).clamp(0.8, 1.35);
      }
      return 0.74;
    }

    return GetBuilder<ThemeController>(
      builder: (controller) {
        if (controller.isLoading && controller.themes.isEmpty) {
          return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
        }

        if (controller.errorMessage != null && controller.themes.isEmpty) {
          return _buildRefreshWrapper(
            context,
            controller,
            Text(controller.errorMessage!, style: TextStyle(color: theme.colorScheme.error))
          );
        }

        if (controller.themes.isEmpty) {
          return _buildRefreshWrapper(
            context,
            controller,
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: theme.hintColor.withOpacity(0.5)),
                  const SizedBox(height: 12),
                  Text('Brak motywów spełniających kryteria', style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor), textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: theme.colorScheme.primary,
          onRefresh: () => controller.fetchThemes(refresh: true),
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // --- TUTAJ BYŁ SLIVERAPPBAR. TERAZ JEST CZYSTY, NIE-DUPLIKUJĄCY SIĘ NAGŁÓWEK ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ThemeSortHeaderWidget(isPersonal: isPersonalView),
                ),
              ),

              // --- SIATKA Z KAFLAMI ---
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: getChildAspectRatio(),
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = controller.themes[index];
                      return ThemeTileWidget(key: ValueKey(item.id), themeItem: item);
                    },
                    childCount: controller.themes.length,
                  ),
                ),
              ),

              if (controller.isLoadingMore)
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 24, top: 16),
                  sliver: SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                  ),
                ),
            ],
          ),
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
          height: MediaQuery.of(context).size.height * 0.5,
          child: Align(alignment: Alignment.center, child: child),
        ),
      ),
    );
  }
}