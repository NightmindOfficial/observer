import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Observer {
  final String name;
  final String email;
  final String uid;
  final DateTime creationTime;
  final String profilePictureURL;
  final String defaultWID;
  final String currentWID;

  Observer({
    required this.name,
    required this.email,
    required this.uid,
    required this.creationTime,
    required this.profilePictureURL,
    required this.defaultWID,
    required this.currentWID,
  });

  Map<String, dynamic> toJSON() => {
        'name': name,
        'email': email,
        'uid': uid,
        'creationTime': creationTime,
        'profilePictureURL': profilePictureURL,
        'defaultWID': defaultWID,
        'currentWID': currentWID,
      };

  static Observer fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> snapshot = snap.data() as Map<String, dynamic>;

    return Observer(
      name: snapshot['name'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      creationTime: snapshot['creationTime'].toDate(),
      profilePictureURL: snapshot['profilePictureURL'],
      defaultWID: snapshot['defaultWID'],
      currentWID: snapshot['currentWID'],
    );
  }
}
