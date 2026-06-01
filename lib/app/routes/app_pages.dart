import 'package:gauge/app/modules/auth/middleware/auth_middleware.dart';
import 'package:gauge/app/modules/auth/view/login_view.dart';
import 'package:gauge/app/modules/auth/view/logout_view.dart';
import 'package:gauge/app/modules/theme/bindings.dart';
import 'package:gauge/app/modules/theme/view/theme_personal_view.dart';
import 'package:gauge/app/modules/theme/view/theme_public_view.dart';
import 'package:get/get.dart';

//modules
import 'package:gauge/app/modules/device/view/device_index_view.dart';
import 'package:gauge/app/modules/device/view/device_show_view.dart';
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
      page: () => DeviceIndexView(),
    ),
    GetPage(
      name: Routes.device,
      page: () => DeviceShowView(),
    ),
    GetPage(
      name: Routes.themes,
      page: () => ThemePublicView(),
      // binding: ThemeBinding(),
    ),
    GetPage(
      name: Routes.myThemes,
      page: () => ThemePersonalView(),
      middlewares: [
        AuthMiddleware(),
      ],
      // binding: ThemeBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => LoginView(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.logout,
      page: () => LogoutView()
    ),
  ];

  static GetPage unknownView = GetPage(name: '/unknown', page: () => const UnknownView());
}
