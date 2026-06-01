import 'package:gauge/app/modules/theme/controller/theme_controller.dart';
import 'package:get/get.dart';

class ThemeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
