import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mangaapp/providers/profile_model.dart';

class FirebaseStorageDialog extends StatefulWidget {
  final ProfileModel profile;
  final String currImage;
  final String? currUsername;
  final Function onSuccess;
  final Function onFailure;

  const FirebaseStorageDialog(
      {Key? key,
      required this.profile,
      required this.currImage,
      required this.onSuccess,
      required this.onFailure,
      this.currUsername})
      : super(key: key);

  @override
  State<FirebaseStorageDialog> createState() => _FirebaseStorageDialogState();
}

class _FirebaseStorageDialogState extends State<FirebaseStorageDialog> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    handleUpload(_storage, widget.profile, widget.currImage,
        widget.currUsername, _firestore, widget.onSuccess, widget.onFailure);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  void handleUpload(
      FirebaseStorage storage,
      ProfileModel profile,
      String currImage,
      String? currUsername,
      FirebaseFirestore firestore,
      Function onSuccess,
      Function onFailure) {
    final photoRef = storage.ref().child('profile_images/${profile.email}');
    try {
      final uploadTask = photoRef.putFile(File(currImage));

      // Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            onFailure();
            break;
          case TaskState.success:
            print('success!');
            String url = await photoRef.getDownloadURL();

            if (currUsername != null) {
              firestore
                  .collection('profile')
                  .doc(profile.email)
                  .update({'username': currUsername, 'profile_image': url});
            } else {
              firestore
                  .collection('profile')
                  .doc(profile.email)
                  .update({'profile_image': url});
            }
            onSuccess();
            break;
        }
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}

void handleUpload(
    FirebaseStorage storage,
    ProfileModel profile,
    String currImage,
    String? currUsername,
    FirebaseFirestore firestore,
    Function onSuccess,
    Function onFailure) {
  final photoRef = storage.ref().child('profile_images/${profile.email}');
  try {
    final uploadTask = photoRef.putFile(File(currImage));

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          onFailure();
          break;
        case TaskState.success:
          print('success!');
          String url = await photoRef.getDownloadURL();

          if (currUsername != null) {
            firestore
                .collection('profile')
                .doc(profile.email)
                .update({'username': currUsername, 'profile_image': url});
          } else {
            firestore
                .collection('profile')
                .doc(profile.email)
                .update({'profile_image': url});
          }
          onSuccess();
          break;
      }
    });
  } on FirebaseException catch (e) {
    print(e);
  }
}
