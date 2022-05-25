import 'package:flutter/material.dart';
import 'package:observer/widgets/text_field_input.dart';

Future<String?> openWorkspaceManipulator({
  required BuildContext context,
  required TextEditingController controller,
  required WorkspaceManipulatorIntent intent,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: intent == WorkspaceManipulatorIntent.add
            ? const Text("Create New Workspace")
            : const Text("Edit Workspace"),
        content: TextFieldInput(
          controller: controller,
          hintText: "Name",
          inputType: TextInputType.text,
          autoFocus: true,
        ),
        actions: intent == WorkspaceManipulatorIntent.add
            ? addActions(context, controller)
            : editActions(context, controller),
      ),
    );

enum WorkspaceManipulatorIntent {
  add,
  edit,
}

List<Widget> addActions(
        BuildContext context, TextEditingController controller) =>
    [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text("Create")),
    ];

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
