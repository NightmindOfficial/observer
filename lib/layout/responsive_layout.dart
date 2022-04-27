import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/global_variables.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget smallScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.smallScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          if (constraints.maxWidth > webScreenSize) {
            return webScreenLayout;
          } else {
            return smallScreenLayout;
          }
        } else {
          return mobileScreenLayout;
        }
      },
    );
  }
}
