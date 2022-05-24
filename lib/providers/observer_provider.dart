import 'package:flutter/material.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/resources/authentication.dart';

class ObserverProvider extends ChangeNotifier {
  Observer? _observer;
  final Authentication _auth = Authentication();

  Observer get observer =>
      _observer ??
      Observer(
        name: "Loading...",
        email: "Loading...",
        uid: "Loading...",
        creationTime: DateTime(1900),
        profilePictureURL:
            'https://firebasestorage.googleapis.com/v0/b/om-observer.appspot.com/o/observerProfiles%2FRZ9pseTFLuWci4ZwfJqStV3ozzf2?alt=media&token=fbfc2ec6-7726-401f-9d40-c5c690c5af01',
      );

  Future<void> refreshObserver() async {
    Observer updatedObserver = await _auth.getObserverDetails();
    _observer = updatedObserver;
    notifyListeners();
  }
}
