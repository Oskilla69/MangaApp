import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:provider/provider.dart';

class AccountPageNoUser extends StatefulWidget {
  const AccountPageNoUser({Key? key}) : super(key: key);
  static const routeName = '/profile_no_user';

  @override
  State<AccountPageNoUser> createState() => _AccountPageNoUserState();
}

class _AccountPageNoUserState extends State<AccountPageNoUser> {
  @override
  Widget build(BuildContext context) {
    return accountSettingsNoUser();
  }

  Widget accountSettingsNoUser() {
    return Scaffold(
        appBar: AppBar(title: const Text('Account')),
        body: Center(
            child: TextButton(
          child: const Text('Login to make changes to your account.'),
          onPressed: () {
            Navigator.pushNamed(context, LoginPage.routeName);
          },
        )));
  }
}
