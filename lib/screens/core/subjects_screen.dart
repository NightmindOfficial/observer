import 'package:flutter/material.dart';
import 'package:observer/helpers/global_variables.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: Text("Open Drawer")),
      ),
    );
  }
}
