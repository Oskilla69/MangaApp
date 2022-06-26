import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  late TextEditingController usernameController =
      TextEditingController(text: Provider.of<ProfileModel>(context).username);

  late String currImage = Provider.of<ProfileModel>(context).profilePic;
  bool changesMade = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(builder: (context, profile, child) {
      String currUsername = profile.username;
      String currProfilePic = profile.profilePic;
      return WillPopScope(
        onWillPop: () async {
          if (changesMade) {
            bool goBack = false;
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'You have unsaved changes. You will lose those changes if you go back.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            goBack = false;
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            goBack = true;
                            Navigator.pop(context);
                          },
                          child: const Text('OK'))
                    ],
                  );
                });
            return goBack;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              title: const Text('Account'),
              // currUsername != newUsername || currProfile != newProfile
              actions: changesMade
                  ? [
                      TextButton(
                          onPressed: () {
                            if (currProfilePic != currImage) {
                              profile.setProfilePic(currImage, true);
                              currProfilePic = currImage;
                            } else if (currUsername !=
                                usernameController.text) {
                              profile.setUsername(
                                  usernameController.text, true);
                              currUsername = usernameController.text;
                              _firestore
                                  .collection('profile')
                                  .doc(profile.email)
                                  .update({'username': currUsername});
                            }

                            changesMade = false;
                          },
                          child: const Text('Save'))
                    ]
                  : []),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ListView(children: [
              SizedBox(
                height: 32.h,
              ),
              Center(
                  child:
                      !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                          ? FutureBuilder<void>(builder: ((BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.done:
                                  return _getProfileImage();
                                default:
                                  if (snapshot.hasError) {
                                    return Text(
                                      'Pick image/video error: ${snapshot.error}}',
                                      textAlign: TextAlign.center,
                                    );
                                  } else {
                                    return _getProfileImage();
                                  }
                              }
                            }))
                          : _getProfileImage()),
              SizedBox(
                height: 32.h,
              ),
              TextField(
                // readOnly: true,
                maxLength: 32,
                controller: usernameController,
                onChanged: (value) {
                  setState(() {
                    changesMade = true;
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Username', border: OutlineInputBorder()),
              )
            ]),
          ),
        ),
      );
    });
  }

  Widget _getProfileImage() {
    return GestureDetector(
        onTap: (() {
          _getImage();
        }),
        child: CircleAvatar(
          radius: 100.h,
          backgroundImage: _displayImage(),
        ));
  }

  // TODO: consider other test cases. Haven't thought about it yet
  ImageProvider<Object> _displayImage() {
    return AssetImage(currImage);
  }

  Future<void> _getImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        if (currImage != image!.path) {
          changesMade = true;
          currImage = image.path;
        }
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (currImage != response.file!.path) {
          changesMade = true;
          currImage = response.file!.path;
        }
      });
    } else {
      print(response.exception);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
