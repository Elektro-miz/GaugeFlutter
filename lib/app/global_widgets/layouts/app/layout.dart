
import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String? title;
  final Widget? content;

  const AppLayout({Key? key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content,
    );
  }

}
