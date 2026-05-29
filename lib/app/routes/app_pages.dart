import 'package:get/get.dart';

//modules
import 'package:gauge/app/modules/device/view/device_list_view.dart';
import 'package:gauge/app/modules/unknown_view.dart';
// import 'package:gauge/app/modules/home/view/home_page.dart';
// import 'package:gauge/app/modules/about/view/about_view.dart';
// import 'package:gauge/app/modules/project/view/project_view.dart';
// import 'package:gauge/app/modules/project/bindings.dart';
// import 'package:gauge/app/modules/task/bindings.dart';
// import 'package:gauge/app/modules/task/view/test_view.dart';

//middlewares
// import 'package:gauge/app/core/middleware/auth.dart';

part 'package:gauge/app/routes/app_routes.dart';

class AppPages {
  static const initial = Routes.deviceSelect;

  static final routes = [
    GetPage(
      name: Routes.deviceSelect,
      page: () => DeviceView(),
    ),
    GetPage(
      name: Routes.device,
      page: () => DeviceView(),
    ),
    GetPage(
      name: Routes.themes,
      page: () => DeviceView(),
    ),
    GetPage(
      name: Routes.myThemes,
      page: () => DeviceView(),
      // middlewares: [
      //   AuthMiddleware(),
      // ],
    ),
  ];

  static GetPage unknownView = GetPage(name: '/unknown', page: () => const UnknownView());
}
