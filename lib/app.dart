// Project Imports
import 'package:flutter/material.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gauge',

      debugShowCheckedModeBanner: false,

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
