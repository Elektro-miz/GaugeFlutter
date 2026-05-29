import 'package:gauge/common.dart';
import 'package:gauge/app/modules/theme/view/controller/theme_controller.dart';
import 'package:gauge/app/modules/theme/view/widgets/theme_tile.dart';

class ThemeList extends StatelessWidget {
  ThemeList({super.key});

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return themeController.obx(
      (state) => (ListView.builder(
        // padding: EdgeInsets.all(20.0),
        itemBuilder: (context, index) {
          final theme = state![index];
          return ThemeTile(
            key: ValueKey(theme),
            theme: theme,
            title: theme.name,
            longPressCallback: () {
            },
          );
        },
        itemCount: state!.length,
      )),
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Text('No data found'),
      onError: (error) => Text(error!),
    );
  }
}
