import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:observer/helpers/global_variables.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/providers/workspace_provider.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
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
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    ObserverProvider _observerProvider = Provider.of<ObserverProvider>(
      context,
      listen: false,
    );
    WorkspaceProvider _workspaceProvider = Provider.of<WorkspaceProvider>(
      context,
      listen: false,
    );
    await _observerProvider.refreshObserver();
    log("${DateFormat.Hms().format(DateTime.now())}: Observer model has been updated.");
    await _workspaceProvider.refreshWorkspace(context);
    log("${DateFormat.Hms().format(DateTime.now())}: Workspace model has been updated.");
  }

  @override
  Widget build(BuildContext context) {
    SizeGuide().init(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) {
          if (constraints.maxWidth > webScreenSize) {
            return widget.webScreenLayout;
          } else {
            return widget.smallScreenLayout;
          }
        } else {
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
