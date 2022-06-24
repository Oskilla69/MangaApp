import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/pages/profile_page.dart';
import 'package:mangaapp/pages/account_settings_page.dart';
import 'package:mangaapp/pages/subscribe_page.dart';

class SideMenu extends StatefulWidget {
  final String? username;
  final String? email;
  const SideMenu({Key? key, this.username, this.email}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? currentUser;
  String username = 'Hello';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUsername(currentUser?.email);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Drawer(
      child: ListView(
        children: [buildHeader(context), buildMenu(context, auth)],
      ),
    );
  }

  void getUsername(String? email) async {
    if (email != null) {
      final data = await _firestore.collection('profile').doc(email).get();
      var name = data.data()?['username'];
      setState(() {
        username = "Hello, $name.";
      });
    }
  }

  Widget buildHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
        accountName: Text(username),
        accountEmail: Text(currentUser?.email ?? 'Sign Up for More Features!'));
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
    return currentUser != null
        ? ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              auth.signOut();
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
