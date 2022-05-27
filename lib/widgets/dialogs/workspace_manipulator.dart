import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/resources/firestore.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:observer/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

Future<String?> workspaceManipulatorAdd(
  BuildContext context,
  TextEditingController controller,
) =>
    showDialog(
        context: context,
        builder: (context) {
          Observer _creator = Provider.of<ObserverProvider>(context).observer;

          return AlertDialog(
            title: const Text("Create new Workspace"),
            content: TextFieldInput(
              controller: controller,
              hintText: "Name",
              inputType: TextInputType.text,
              autoFocus: true,
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    String res = await Firestore().createNewWorkspace(
                      name: controller.text,
                      creator: _creator,
                      persistent: false,
                    );
                    showSnackbar(
                      res == "success"
                          ? "Workspace '${controller.text}' created successfully."
                          : res,
                      context,
                      snackbarIntent: res == "success"
                          ? SnackbarIntent.info
                          : SnackbarIntent.error,
                    );

                    Navigator.of(context).pop(res);
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(
                      color: accentColor,
                    ),
                  )),
            ],
          );
        });

Future<String?> workspaceManipulatorEdit(
  BuildContext context,
  TextEditingController _nameController,
  Map<String, dynamic> workspace,
) {
  Observer currentObserver = Provider.of<ObserverProvider>(
    context,
    listen: false,
  ).observer;

  _nameController.text = workspace['name'];
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Workspace"),
          content: TextFieldInput(
            controller: _nameController,
            hintText: "Name",
            inputType: TextInputType.text,
            autoFocus: true,
          ),
          actions: [
            TextButton(
              onPressed: (currentObserver.uid == workspace['ownerUID'] &&
                      !workspace['persistent'])
                  ? () {}
                  : null,
              child: Text(
                "Delete",
                style: TextStyle(
                  color: (currentObserver.uid == workspace['ownerUID'] &&
                          !workspace['persistent'])
                      ? errorColor
                      : mobileSearchColor,
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  String res = await Firestore().editExistingWorkspace(
                    name: _nameController.text,
                    workspace: workspace,
                  );
                  showSnackbar(
                    res == "success" ? "Workspace updated successfully." : res,
                    context,
                    snackbarIntent: res == "success"
                        ? SnackbarIntent.info
                        : SnackbarIntent.error,
                  );

                  Navigator.of(context).pop(res);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: accentColor,
                  ),
                )),
          ],
        );
      });
}

List<Widget> editActions(
        BuildContext context, TextEditingController controller) =>
    [
      TextButton(
        onPressed: () {},
        child: const Text("Delete"),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(controller.text);
        },
        child: const Text("Update"),
      ),
    ];
