import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/pages/profile_page.dart';
import 'package:mangaapp/pages/account_settings_page.dart';
import 'package:mangaapp/pages/subscribe_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  final String username;
  final String? email;
  const SideMenu({Key? key, this.username = '', this.email}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Drawer(
      child: ListView(
        children: [buildHeader(context), buildMenu(context, auth)],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: widget.username.isNotEmpty
            ? Text("Hello, ${widget.username}")
            : const Text("Hello"),
        accountEmail: Text(widget.email ?? 'Sign Up for More Features!'));
  }

  Widget buildMenu(BuildContext context, FirebaseAuth auth) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Profile'),
          onTap: () {
            Navigator.pushNamed(context, ProfilePage.routeName);
          },
        ),
        ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, AccountSettingsPage.routeName);
            }),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Subscribe'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, SubscribeOverlay());
          },
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text('Offline Mode'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Bookmarks'),
          onTap: () {},
        ),
        _buildAuthTile(auth),
      ],
    );
  }

  Widget _buildAuthTile(FirebaseAuth auth) {
    return widget.email != null
        ? ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              auth.signOut();
              SharedPreferences.getInstance()
                  .then((preferences) => preferences.clear());
              Navigator.of(context).pushNamed(LoginPage.routeName);
            })
        : ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.of(context).pushNamed(LoginPage.routeName);
            });
  }
}
