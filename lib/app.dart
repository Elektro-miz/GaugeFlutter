// Project Imports
import 'package:gauge/app/routes/app_pages.dart';
import 'package:gauge/common.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gauge',

      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,

      /// Controllers disposing
      smartManagement: SmartManagement.full,

      /// Localization settings(for translations)

      /// Routing Settings
      initialRoute: AppPages.initial, //'/',
      getPages: AppPages.routes,
      unknownRoute: AppPages.unknownView,
      transitionDuration: const Duration(seconds: 0),
    );
  }
}
