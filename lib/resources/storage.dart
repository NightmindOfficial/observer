import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:observer/resources/authentication.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Adding Image to Firebase Storage

  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
    UploadType uploadType,
  ) async {
    Reference uploadFolder =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask uploadTask = uploadFolder.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String pictureURL = await snapshot.ref.getDownloadURL();

    return pictureURL;
  }
}

enum UploadType {
  profilePicture,
  subjectPicture,
  evidence,
}
