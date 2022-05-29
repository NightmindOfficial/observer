import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/models/workspace.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/providers/workspace_provider.dart';
import 'package:provider/provider.dart';
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
      String wid = const Uuid().v4();
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
      log("${DateFormat.Hms().format(DateTime.now())}: Workspace created. Name: $name, WID: $wid, Owner: ${creator.name} (UID: ${creator.uid})");

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
    required BuildContext context,
  }) async {
    String res = "An unknown error occured.";
    WorkspaceProvider _workspaceProvider =
        Provider.of<WorkspaceProvider>(context, listen: false);

    try {
      if (3 > name.length || 17 < name.length) {
        throw ("Please use a workspace name of 3-17 characters. (${name.length})");
      }

      bool nameExists = await doesSimilarDocumentAlreadyExist(
        collectionName: 'workspaces',
        fieldOne: ['name', name],
        fieldTwo: ['ownerUID', workspace['ownerUID']],
      );
      if (nameExists) {
        throw ("The workspace name already exists.");
      }

      //Update the firestore model
      _firestore.collection('workspaces').doc(workspace['wid']).update(
        {
          'name': name,
        },
      );
      await _workspaceProvider.refreshWorkspace(context);
      log("${DateFormat.Hms().format(DateTime.now())}: Workspace updated. New name: $name, WID: ${workspace['wid']}, Owner: ${workspace['ownerName']} (UID: ${workspace['ownerUID']})");

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // DELETE WORKSPACE AND RETURN TO DEFAULT WORKSPACE IF NECESSARY

  Future<String> deleteWorkspace({
    required Map<String, dynamic> workspace,
    required BuildContext context,
  }) async {
    String res = "An unknown error occurred.";
    ObserverProvider _observerProvider =
        Provider.of<ObserverProvider>(context, listen: false);
    WorkspaceProvider _workspaceProvider =
        Provider.of<WorkspaceProvider>(context, listen: false);

    //Firstly, delete the entry from firestore

    try {
      await _firestore.collection('workspaces').doc(workspace['wid']).delete();
      log("${DateFormat.Hms().format(DateTime.now())}: Workspace deleted. Name: ${workspace['name']}, WID: ${workspace['wid']}, Owner: ${workspace['ownerName']} (UID: ${workspace['ownerUID']})");

      //Then check if any users have the workspace set as their currentWID and reroute them to their respective default repositories if necessary

      var snapshots = _firestore
          .collection('observers')
          .where('currentWID', isEqualTo: workspace['wid'])
          .snapshots();

      snapshots.forEach((element) async {
        List<DocumentSnapshot> documents = element.docs;

        for (var document in documents) {
          String _defaultWID = document.get('defaultWID');

          await document.reference.update({'currentWID': _defaultWID});
        }
      });

      // Here, instead of only editing the models it is easier to just refresh everything from the server.
      await _observerProvider.refreshObserver();
      await _workspaceProvider.refreshWorkspace(context);

      res = "success";
    } catch (e) {
      return e.toString();
    }

    return res;
  }

  // UPDATE THE CURRENT WID OF AN OBSERVER

  Future<String> updateSelectedWorkspace(
    BuildContext context,
    Map<String, dynamic> workspace,
  ) async {
    ObserverProvider _observerProvider =
        Provider.of<ObserverProvider>(context, listen: false);
    WorkspaceProvider _workspaceProvider =
        Provider.of<WorkspaceProvider>(context, listen: false);
    String res = "An unknown error occurred.";

    try {
      // Firstly, update the currentWID entry of the current observer

      await _firestore
          .collection('observers')
          .doc(_observerProvider.observer.uid)
          .update(
        {
          'currentWID': workspace['wid'],
        },
      );

      // Then update the workspace provider.

      _workspaceProvider
          .manuallyPushNewWorkspace(Workspace.fromJSON(workspace));

      // Finally, update the Observer provider.

      _observerProvider.updateCurrentWID(workspace['wid']);
      res = "success";
    } catch (e) {
      return e.toString();
    }

    return res;
  }

  // RETURN WORKSPACE MODEL CURRENTLY SELECTED

  Future<Workspace> getSelectedWorkspace(Observer observer) async {
    DocumentSnapshot snap = await _firestore
        .collection('workspaces')
        .doc(observer.currentWID)
        .get();

    return Workspace.fromSnap(snap);
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

  //Check if any documents already have two given values
  Future<bool> doesSimilarDocumentAlreadyExist({
    required String collectionName,
    required List fieldOne,
    required List fieldTwo,
  }) async {
    final QuerySnapshot result = await _firestore
        .collection(collectionName)
        .where(
          fieldOne[0],
          isEqualTo: fieldOne[1],
        )
        .where(
          fieldTwo[0],
          isEqualTo: fieldTwo[1],
        )
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
