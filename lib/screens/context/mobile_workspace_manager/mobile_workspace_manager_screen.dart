import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:observer/widgets/dialogs/workspace_manipulator.dart';
import 'package:observer/widgets/mobile_navigation.dart';

class MobileWorkspaceManagerScreen extends StatefulWidget {
  const MobileWorkspaceManagerScreen({Key? key}) : super(key: key);

  @override
  State<MobileWorkspaceManagerScreen> createState() =>
      _MobileWorkspaceManagerScreenState();
}

class _MobileWorkspaceManagerScreenState
    extends State<MobileWorkspaceManagerScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MobileNavigation(
        fallbackTitle: "Manage Workspaces",
        showMobileUAC: false,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                _nameController.clear();
                final String? res = await openWorkspaceManipulator(
                  context: context,
                  controller: _nameController,
                  intent: WorkspaceManipulatorIntent.add,
                );
                if (res == null || res.isEmpty) {
                  showSnackbar(
                    "Aborted Manipulation (cancelled by user).",
                    context,
                    snackbarIntent: SnackbarIntent.warning,
                  );
                  return;
                }
                log(res);
              },
              child: const Text("Create Workspace"),
            ),
            TextButton(
              onPressed: () async {
                _nameController.clear();
                final String? res = await openWorkspaceManipulator(
                  context: context,
                  controller: _nameController..text = 'Emil',
                  intent: WorkspaceManipulatorIntent.edit,
                );
                if (res == null || res.isEmpty) {
                  showSnackbar(
                    "Aborted Manipulation (cancelled by user).",
                    context,
                    snackbarIntent: SnackbarIntent.warning,
                  );
                  return;
                }
                log(res);
              },
              child: const Text('Update Workspace named "Emil"'),
            ),
          ],
        ),
      ),
    );
  }
}
