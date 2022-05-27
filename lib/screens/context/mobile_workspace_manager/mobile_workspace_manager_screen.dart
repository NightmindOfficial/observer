import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/global_variables.dart';
import 'package:observer/helpers/no_glow.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/resources/firestore.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:observer/widgets/buttons/query_button.dart';
import 'package:observer/widgets/cards/workspace_card.dart';
import 'package:observer/widgets/dialogs/workspace_manipulator.dart';
import 'package:observer/widgets/mobile_navigation.dart';
import 'package:provider/provider.dart';

class MobileWorkspaceManagerScreen extends StatefulWidget {
  const MobileWorkspaceManagerScreen({Key? key}) : super(key: key);

  @override
  State<MobileWorkspaceManagerScreen> createState() =>
      _MobileWorkspaceManagerScreenState();
}

class _MobileWorkspaceManagerScreenState
    extends State<MobileWorkspaceManagerScreen> {
  late TextEditingController _nameController;
  late int ownNumberOfWorkspaces;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createNewWorkspace() async {
    _nameController.clear();
    final String? res = await workspaceManipulatorAdd(
      context,
      _nameController,
    );

    if (res == null || res.isEmpty) {
      showSnackbar(
        "Aborted Manipulation (cancelled by user).",
        context,
        snackbarIntent: SnackbarIntent.warning,
      );
      return;
    }
  }

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
    Observer currentObserver = Provider.of<ObserverProvider>(context).observer;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MobileNavigation(
        fallbackTitle: "Manage Workspaces",
        showMobileUAC: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: const Text(
              "YOUR WORKSPACES",
              style: TextStyle(
                  fontSize: 16, color: secondaryColor, letterSpacing: 2),
            ),
          ),
          StreamBuilder(
            stream: _firestore
                .collection('workspaces')
                .where('ownerUID', isEqualTo: currentObserver.uid)
                // .orderBy('name')
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: accentColor,
                ));
              } else if (!snapshot.hasData) {
                return const Text("Error.");
              } else if (snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "There are no workspaces associated to your account.",
                    style: TextStyle(
                      color: mobileSearchColor,
                    ),
                  ),
                );
              }
              return Container(
                constraints: BoxConstraints(
                    maxHeight: proportionateScreenHeightFraction(
                        ScreenFraction.onethird)),
                child: ScrollConfiguration(
                  behavior: NoGlow(),
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return WorkspaceCard(
                          snapshot.data!.docs[index].data(),
                          subtext: WorkspaceSubtext.wid,
                        );
                      })),
                ),
              );
            },
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: const Text(
              "SHARED WITH YOU",
              style: TextStyle(
                  fontSize: 16, color: secondaryColor, letterSpacing: 2),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('workspaces')
                  .where('ownerUID', arrayContains: currentObserver.uid)
                  // .orderBy('name')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: accentColor,
                  ));
                } else if (!snapshot.hasData) {
                  return const Text("Error.");
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "There are no workspaces shared with you currently.",
                      style: TextStyle(
                        color: mobileSearchColor,
                      ),
                    ),
                  );
                }
                return ScrollConfiguration(
                  behavior: NoGlow(),
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return WorkspaceCard(
                          snapshot.data!.docs[index].data(),
                          subtext: WorkspaceSubtext.wid,
                        );
                      })),
                );
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: QueryButton(
                child: Text(
                  "Create new Workspace",
                  style: buttonTextStyle,
                ),
                onPressed: () => createNewWorkspace(),
                isLoading: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
