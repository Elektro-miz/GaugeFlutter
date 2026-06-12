
import 'package:flutter/material.dart';
import 'package:gauge/app/modules/auth/controller/auth_controller.dart';
import 'package:gauge/app/routes/app_pages.dart';
import 'package:gauge/common.dart';

class AppLayout extends StatelessWidget {
  final String? title;
  final Widget? content;
  final AppBar? appbar;

  const AppLayout({Key? key, this.title, this.content, this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content,
      appBar: getAppBar(),
    );
  }

  AppBar getAppBar() {
    return appbar ?? AppBar(title: Text(title!));
  }

  static List<Widget> getAppBarActions()
  {
    final AuthController authController = Get.find();
    List<Widget> actions = [];
    if(authController.isLoggedIn())
    {
      actions.add(IconButton(
        icon:Icon(LucideIcons.logOut),
        onPressed: () =>  Get.toNamed(Routes.logout),
      ));
    } else {
       actions.add(IconButton(
        icon:Icon(LucideIcons.logIn),
        onPressed: () =>  Get.toNamed(Routes.auth),
      ));
    }
    return actions;
  }
}
