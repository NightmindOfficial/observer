import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/models/workspace.dart';
import 'package:uuid/uuid.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE A NEW WORKSPACE

  Future<String> createNewWorkspace({
    required String name,
    required Observer creator,
    required bool persistent,
  }) async {
    String res = "An unknown error occured.";
    try {
      if (3 > name.length || 17 < name.length) {
        throw ("Please use a workspace name of 3-17 characters. (${name.length})");
      }

      bool nameExists = await doesValueAlreadyExist(
          collectionName: 'workspaces', fieldName: 'name', fieldValue: name);
      if (nameExists) {
        throw ("This workspace already exists.");
      }
      //Create Workspace Model
      String wid = const Uuid().v1();
      Workspace workspace = Workspace(
        name: name,
        wid: wid,
        ownerUID: creator.uid,
        ownerName: creator.name,
        ownerProfilePicURL: creator.profilePictureURL,
        creationTime: DateTime.now(),
        allowEditing: [],
        persistent: persistent,
      );

      //Upload the model to Firestore
      _firestore.collection('workspaces').doc(wid).set(workspace.toJSON());
      log("Workspace created. Name: $name, WID: $wid, Owner: ${creator.name} (UID: ${creator.uid})");

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //EDIT EXISTING WORKSPACE

  Future<String> editExistingWorkspace({
    required String name,
    required Map<String, dynamic> workspace,
  }) async {
    String res = "An unknown error occured.";
    try {
      if (3 > name.length || 17 < name.length) {
        throw ("Please use a workspace name of 3-17 characters. (${name.length})");
      }

      bool nameExists = await doesValueAlreadyExist(
          collectionName: 'workspaces', fieldName: 'name', fieldValue: name);
      if (nameExists) {
        throw ("This workspace already exists.");
      }

      //Update the firestore model
      _firestore.collection('workspaces').doc(workspace['wid']).update(
        {
          'name': name,
        },
      );
      log("Workspace updated. New name: $name, WID: ${workspace['wid']}, Owner: ${workspace['ownerName']} (UID: ${workspace['ownerUID']})");

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //Check if any documents already have a given value
  Future<bool> doesValueAlreadyExist({
    required String collectionName,
    required String fieldName,
    required String fieldValue,
  }) async {
    final QuerySnapshot result = await _firestore
        .collection(collectionName)
        .where(fieldName, isEqualTo: fieldValue)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

//Count number of Documents available that match a certain attribute
  Future<int> numberOfFirestoreDocsMatching({
    required String collectionName,
    required String fieldName,
    required String fieldValue,
  }) async {
    final QuerySnapshot result = await _firestore
        .collection(collectionName)
        .where(fieldName, isEqualTo: fieldValue)
        .get();

    return result.docs.length;
  }
}
