import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangaapp/pages/login_page.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [buildHeader(context), buildMenu(context, _auth)],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: Text('Hello'), accountEmail: Text('accountEmail'));
  }

  Widget buildMenu(BuildContext context, FirebaseAuth auth) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Profile'),
          onTap: () {},
        ),
        ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {}),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Subscribe'),
          onTap: () {},
        ),
        ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              auth.signOut();
              Navigator.of(context).pushNamed(LoginPage.routeName);
            }),
      ],
    );
  }
}
