import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/widgets/dialogs/workspace_manipulator.dart';

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
    // final String url = FirebaseFirestore.instance.collection('observers').doc(snap['ownerUID']).

    return Padding(
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
            snap['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontStyle: snap['persistent'] ? FontStyle.italic : null,
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
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.black.withAlpha(128),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                if (snap['persistent'])
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: accentColor.withAlpha(100),
                  ),
              ],
            ),
          ),
          trailing: IconButton(
              onPressed: () {
                workspaceManipulatorEdit(context, _nameController, snap);
              },
              icon: const Icon(
                Icons.edit_rounded,
                color: accentColor,
              )),
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
