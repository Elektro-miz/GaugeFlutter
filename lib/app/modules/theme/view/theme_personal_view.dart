import 'package:flutter/material.dart';
import 'package:gauge/app/global_widgets/layouts/app/layout.dart';
import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:gauge/app/modules/theme/widgets/theme_list.dart';
import 'package:gauge/app/modules/theme/widgets/theme_sort_header_widget.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:gauge/app/global_widgets/layouts/app/responsive_layout.dart';

class ThemePersonalView extends StatelessWidget {
  ThemePersonalView({super.key});

  final ThemeController controller = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const title = 'Moje motywy';
    final isWide = context.isDesktop || context.isDeviceLandscape;

    // TUTAJ TEŻ NIE MA JUŻ CONST!
    return AppLayout(
      title: title,
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Expanded(
                child: ThemeListWidget(
                  isPersonalView: true,
                ),
              ),
            ],
          ),
        ),
      ),
      appbar: AppBar(
        title: Text(title!),
        actions: AppLayout.getAppBarActions(),
      ),
    );
  }
}