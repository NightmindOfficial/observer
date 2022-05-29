import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/models/workspace.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/providers/workspace_provider.dart';
import 'package:observer/resources/authentication.dart';
import 'package:observer/screens/auth/login_screen.dart';
import 'package:observer/screens/context/mobile_workspace_manager/mobile_workspace_manager_screen.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:observer/widgets/account_avatar.dart';
import 'package:provider/provider.dart';

class MobileAccountControl extends StatelessWidget {
  const MobileAccountControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Observer observer = Provider.of<ObserverProvider>(context).observer;
    Workspace workspace = Provider.of<WorkspaceProvider>(context).workspace;

    return Drawer(
      backgroundColor: mobileSearchColor,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    "Hello, ${observer.name}",
                    style: const TextStyle(
                      color: mobileBackgroundColor,
                    ),
                  ),
                  accountEmail: Text(
                    observer.email,
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                  currentAccountPicture: const AccountAvatar(link: false),
                  onDetailsPressed: () => log("Tapped!"),
                ),
                ...ListTile.divideTiles(
                  context: context,
                  tiles: [
                    ListTile(
                      leading: const Icon(Icons.workspaces_rounded),
                      title: const Text("Manage my workspaces"),
                      subtitle: Text("Active: ${workspace.name}"),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MobileWorkspaceManagerScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 64,
            child: Row(
              children: [
                IconButton(
                  iconSize: 36,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: accentColor,
                        // padding: EdgeInsets.zero,
                        // splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () async {
                        await Authentication().signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) => const LoginScreen()),
                          ),
                        );
                        showSnackbar(
                            "Connection to Observer Network terminated.",
                            context);
                      },
                      child: const Text(
                        "Disconnect",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: mobileBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
