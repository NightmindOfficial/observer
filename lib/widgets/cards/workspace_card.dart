import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/resources/firestore.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:observer/widgets/dialogs/workspace_manipulator.dart';
import 'package:provider/provider.dart';

class WorkspaceCard extends StatelessWidget {
  final Map<String, dynamic> snap;
  final WorkspaceSubtext subtext;
  const WorkspaceCard(
    this.snap, {
    Key? key,
    this.subtext = WorkspaceSubtext.wid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    Observer _currentObserver = Provider.of<ObserverProvider>(context).observer;
    final bool _isActive = _currentObserver.currentWID == snap['wid'];
    // final String url = FirebaseFirestore.instance.collection('observers').doc(snap['ownerUID']).

    return GestureDetector(
      onTap: () => Firestore().updateSelectedWorkspace(context, snap),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          8,
          0,
          8,
          8,
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            isThreeLine: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            tileColor: mobileSearchColor,
            title: Text(
              (snap['persistent'] && snap['ownerUID'] == _currentObserver.uid)
                  ? "${snap['name']} [Default]"
                  : "${snap['name']}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: (snap['persistent'] &&
                        snap['ownerUID'] == _currentObserver.uid)
                    ? FontStyle.italic
                    : null,
              ),
            ),
            subtitle: Text(
              (() {
                switch (subtext) {
                  case WorkspaceSubtext.ownerName:
                    return "Owner: ${snap['ownerName']}";
                  case WorkspaceSubtext.wid:
                    return "WID: ${snap['wid']}";
                  default:
                    return "Owner: ${snap['ownerName']}\n${snap['wid']}";
                }
              })(),
              textAlign: TextAlign.center,
            ),
            leading: SizedBox(
              width: proportionateScreenWidthFraction(ScreenFraction.onefifth),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(snap['ownerProfilePicURL']),
                    maxRadius: 28,
                  ),
                  if (_isActive)
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.black.withAlpha(128),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            trailing: IconButton(
                onPressed: () async {
                  String? res = await workspaceManipulatorEdit(
                      context, _nameController, snap);
                  if (res != "success" && res != "DELETE") {
                    showSnackbar(
                      res ?? "Aborted Manipulation (cancelled by user).",
                      context,
                      snackbarIntent: SnackbarIntent.warning,
                    );
                  }
                  if (res == "DELETE") {
                    String? resTwo =
                        await workspaceManipulatorDelete(context, snap);
                    if (resTwo != "success") {
                      showSnackbar(
                        resTwo ?? "Aborted Manipulation (cancelled by user).",
                        context,
                        snackbarIntent: SnackbarIntent.warning,
                      );
                    }
                  }
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  color: accentColor,
                )),
          ),
        ),
      ),
    );
  }
}

enum WorkspaceSubtext {
  ownerName,
  wid,
  both,
}
