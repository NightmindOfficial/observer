import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/models/workspace.dart';
import 'package:observer/resources/storage.dart';
import 'package:uuid/uuid.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SIGN UP

  Future<String> signUpUser({
    required String email,
    required String passphrase,
    required String name,
    required Uint8List? profilepic,
  }) async {
    String computationResult =
        "An unknown error occurred. Please contact administrator.";

    try {
      if (email.isNotEmpty &&
          passphrase.isNotEmpty &&
          name.length >= 3) // && profilepic != null)
      {
        //register new user in FirebaseAuth
        UserCredential userCredentials = await _auth
            .createUserWithEmailAndPassword(email: email, password: passphrase);

        //Upload Profile Picture
        String profilePictureURL;

        if (profilepic != null) {
          profilePictureURL = await Storage().uploadImageToStorage(
            'observerProfiles',
            profilepic,
            UploadType.profilePicture,
          );
        } else {
          profilePictureURL =
              'https://firebasestorage.googleapis.com/v0/b/om-observer.appspot.com/o/observerProfiles%2FRZ9pseTFLuWci4ZwfJqStV3ozzf2?alt=media&token=fbfc2ec6-7726-401f-9d40-c5c690c5af01';
        }

        //add user to database in FirebaseFirestore
        Observer newObserver = Observer(
          name: name,
          email: email,
          uid: userCredentials.user!.uid,
          creationTime: DateTime.now(),
          profilePictureURL: profilePictureURL,
        );

        await _firestore
            .collection('observers')
            .doc(userCredentials.user!.uid)
            .set(newObserver.toJSON());

        //Set up the default workspace for the new user without triggering another Snackbar

        String defaultWID = const Uuid().v1();

        Workspace defaultWorkspace = Workspace(
          name: "Default Workspace",
          wid: defaultWID,
          ownerUID: userCredentials.user!.uid,
          ownerName: name,
          ownerProfilePicURL: profilePictureURL,
          creationTime: DateTime.now(),
          allowEditing: [],
          persistent: true,
        );

        await _firestore
            .collection('workspaces')
            .doc(defaultWID)
            .set(defaultWorkspace.toJSON());

        computationResult = "Observer node created successfully.";
      } else if (name.length < 3) {
        computationResult = "Please use a name of at least three characters.";
      } else {
        computationResult = "Please fill all required data points.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          //Thrown if the email address is not valid.
          computationResult = "The Observer ID used is not valid.";
          break;

        case 'email-already-in-use':
          //Thrown if there already exists an account with the given email address.
          computationResult = "This Observer ID is already in use.";
          break;

        case 'operation-not-allowed':
          //Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
          computationResult =
              "Currently, no more Observer Accounts can be created.";
          break;

        case 'weak-password':
          //Thrown if the password is not strong enough.
          computationResult = "Your password does not meet security standards.";
          break;
      }
    } catch (e) {
      computationResult = e.toString();
    }
    return computationResult;
  }

  /// LOGIN

  Future<String> signInUser({
    required String mail,
    required String pass,
  }) async {
    String computationResult =
        "An unknown error occurred. Please contact administrator.";

    try {
      if (mail.isNotEmpty && pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: mail, password: pass);
        computationResult = "Connection to Observer Network established.";
      } else if (mail.isEmpty) {
        computationResult = "Please enter your Observer ID.";
      } else if (pass.isEmpty) {
        computationResult = "Please enter your passphrase.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          //Thrown if the email address is not valid.
          computationResult = "The Observer ID is not valid.";
          break;

        case 'user-disabled':
          //Thrown if the user corresponding to the given email has been disabled.
          computationResult =
              "This Observer ID has been terminated until further notices.";
          break;

        case 'user-not-found':
          //Thrown if there is no user corresponding to the given email.
          computationResult =
              "No observer record was found with the given credentials.";
          break;

        case 'wrong-password':
          // Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
          computationResult = "Your credentials are invalid.";
          break;
      }
    } catch (e) {
      computationResult = e.toString();
    }
    return computationResult;
  }

  /// PASS OBSERVER DATA ON TO PROVIDER

  Future<Observer> getObserverDetails() async {
    User currentObserver = _auth.currentUser!;
    // log("Fetching data for ${currentObserver.uid}");

    DocumentSnapshot snap =
        await _firestore.collection('observers').doc(currentObserver.uid).get();

    // log("Got Data: ${snap.data().toString()}");
    return Observer.fromSnap(snap);
  }
}
