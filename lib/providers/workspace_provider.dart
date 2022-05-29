import 'package:flutter/cupertino.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/models/workspace.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/resources/firestore.dart';
import 'package:provider/provider.dart';

class WorkspaceProvider extends ChangeNotifier {
  Workspace _workspace = Workspace(
    name: "Loading...",
    wid: "Loading...",
    ownerUID: "Loading...",
    ownerName: "Loading...",
    ownerProfilePicURL: "Loading...",
    creationTime: DateTime(1900),
    allowEditing: [],
    persistent: false,
  );
  final Firestore _firestore = Firestore();

  Workspace get workspace => _workspace;

  String get currentWID => _workspace.wid;

  Future<void> refreshWorkspace(BuildContext context) async {
    Observer currentObserver = Provider.of<ObserverProvider>(
      context,
      listen: false,
    ).observer;
    Workspace updatedWorkspace =
        await _firestore.getSelectedWorkspace(currentObserver);
    _workspace = updatedWorkspace;
    notifyListeners();
  }

  void manuallyPushNewWorkspace(Workspace workspace) {
    _workspace = workspace;
    notifyListeners();
  }
}
