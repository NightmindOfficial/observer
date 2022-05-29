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
                  ? () async {
                      Navigator.of(context).pop("DELETE");
                    }
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
                    context: context,
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

Future<String?> workspaceManipulatorDelete(
    BuildContext context, Map<String, dynamic> workspace) {
  TextEditingController _confirmationController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Deleting a workspace is permanent and CANNOT be undone. Be aware that you might lose all your intel.\n\nTo make sure you understand the impact of your actions, please type in the name of the workspace again.",
              ),
              const SizedBox(
                height: 16,
              ),
              TextFieldInput(
                  controller: _confirmationController,
                  hintText: 'Type "${workspace['name']}"'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (_confirmationController.text == workspace['name']) {
                  String res = await Firestore().deleteWorkspace(
                    workspace: workspace,
                    context: context,
                  );
                  showSnackbar(
                    res == "success" ? "Workspace deleted successfully." : res,
                    context,
                    snackbarIntent: res == "success"
                        ? SnackbarIntent.info
                        : SnackbarIntent.error,
                  );

                  Navigator.of(context).pop(res);
                } else {
                  Navigator.of(context)
                      .pop("Deletion aborted: Safety Check not passed");
                }
              },
              child: const Text(
                "Yes, delete all my data",
                style: TextStyle(
                  color: errorColor,
                ),
              ),
            ),
          ],
        );
      });
}
