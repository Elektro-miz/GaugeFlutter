import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 768;
  static bool isTablet(BuildContext context) => MediaQuery.sizeOf(context).width >= 768 && MediaQuery.sizeOf(context).width < 1024;
  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 1024;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024 && desktop != null) return desktop!;
        if (constraints.maxWidth >= 768 && tablet != null) return tablet!;
        return mobile;
      },
    );
  }
}

extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveLayout.isMobile(this);
  bool get isTablet => ResponsiveLayout.isTablet(this);
  bool get isDesktop => ResponsiveLayout.isDesktop(this);
  bool get isDeviceLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;
}