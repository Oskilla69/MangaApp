import 'package:flutter/material.dart';
import '../login_page/screens/login_page.dart';

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
