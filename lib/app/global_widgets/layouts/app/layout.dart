
import 'package:flutter/material.dart';

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

}
