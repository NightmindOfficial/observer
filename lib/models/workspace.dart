import 'package:cloud_firestore/cloud_firestore.dart';

class Workspace {
  final String name;
  final String wid;
  final String ownerUID;
  final String ownerName;
  final String ownerProfilePicURL;
  final DateTime creationTime;
  final List allowEditing;
  final bool persistent;

  Workspace({
    required this.name,
    required this.wid,
    required this.ownerUID,
    required this.ownerName,
    required this.ownerProfilePicURL,
    required this.creationTime,
    required this.allowEditing,
    required this.persistent,
  });

  Map<String, dynamic> toJSON() => {
        'name': name,
        'wid': wid,
        'ownerUID': ownerUID,
        'ownerName': ownerName,
        'ownerProfilePicURL': ownerProfilePicURL,
        'creationTime': creationTime,
        'allowEditing': allowEditing,
        'persistent': persistent,
      };

  static Workspace fromJSON(Map<String, dynamic> workspace) => Workspace(
        name: workspace['name'],
        wid: workspace['wid'],
        ownerUID: workspace['ownerUID'],
        ownerName: workspace['ownerName'],
        ownerProfilePicURL: workspace['ownerProfilePicURL'],
        creationTime: workspace['creationTime'].toDate(),
        allowEditing: workspace['allowEditing'],
        persistent: workspace['persistent'],
      );

  static Workspace fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;

    return Workspace(
      name: snapshot['name'],
      wid: snapshot['wid'],
      ownerUID: snapshot['ownerUID'],
      ownerName: snapshot['ownerName'],
      ownerProfilePicURL: snapshot['ownerProfilePicURL'],
      creationTime: snapshot['creationTime'].toDate(),
      allowEditing: snapshot['allowEditing'],
      persistent: snapshot['persistent'],
    );
  }
}
