import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mangaapp/pages/account_page_no_user.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/pages/account_page.dart';
import 'package:mangaapp/pages/account_settings_page.dart';
import 'package:mangaapp/pages/subscribe_page.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Consumer<ProfileModel>(builder: (context, profile, child) {
      return ListView(children: [
        buildHeader(context, profile),
        buildMenu(context, profile)
      ]);
    }));
  }

  Widget buildHeader(BuildContext context, ProfileModel profile) {
    return profile.profilePic.startsWith('https://')
        ? UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(profile.profilePic)),
            accountName: profile.username.isNotEmpty
                ? Text("Hello, ${profile.username}")
                : const Text("Hello"),
            accountEmail: Text(profile.email.isNotEmpty
                ? profile.email
                : 'Sign Up for More Features!'))
        : UserAccountsDrawerHeader(
            currentAccountPicture:
                CircleAvatar(backgroundImage: AssetImage(profile.profilePic)),
            accountName: profile.username.isNotEmpty
                ? Text("Hello, ${profile.username}")
                : const Text("Hello"),
            accountEmail: Text(profile.email.isNotEmpty
                ? profile.email
                : 'Sign Up for More Features!'));
  }

  Widget buildMenu(BuildContext context, ProfileModel profile) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Account'),
          onTap: () {
            if (_auth.currentUser == null) {
              Navigator.pushNamed(context, AccountPageNoUser.routeName);
            } else {
              Navigator.pushNamed(context, AccountPage.routeName);
            }
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
        _buildAuthTile(context, profile),
      ],
    );
  }

  Widget _buildAuthTile(BuildContext context, ProfileModel profile) {
    return profile.email.isNotEmpty
        ? ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              _auth.signOut();
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

// class SideMenu extends StatefulWidget {
//   final String username;
//   final String profilePic;
//   final String? email;
//   const SideMenu(
//       {Key? key,
//       this.profilePic = 'assets/images/logo.jpeg',
//       this.username = '',
//       this.email})
//       : super(key: key);

//   @override
//   State<SideMenu> createState() => _SideMenuState();
// }

// class _SideMenuState extends State<SideMenu> {
//   @override
//   Widget build(BuildContext context) {
//     final auth = FirebaseAuth.instance;
//     return Drawer(
//       child: ListView(
//         children: [buildHeader(context), buildMenu(context, auth)],
//       ),
//     );
//   }

//   Widget buildHeader(BuildContext context) {
//     return widget.profilePic.startsWith('https://')
//         ? UserAccountsDrawerHeader(
//             currentAccountPicture: CircleAvatar(
//                 backgroundImage: CachedNetworkImageProvider(widget.profilePic)),
//             accountName: widget.username.isNotEmpty
//                 ? Text("Hello, ${widget.username}")
//                 : const Text("Hello"),
//             accountEmail: Text(widget.email ?? 'Sign Up for More Features!'))
//         : UserAccountsDrawerHeader(
//             currentAccountPicture:
//                 CircleAvatar(backgroundImage: AssetImage(widget.profilePic)),
//             accountName: widget.username.isNotEmpty
//                 ? Text("Hello, ${widget.username}")
//                 : const Text("Hello"),
//             accountEmail: Text(widget.email ?? 'Sign Up for More Features!'));
//   }

//   Widget buildMenu(BuildContext context, FirebaseAuth auth) {
//     return Column(
//       children: [
//         ListTile(
//           leading: const Icon(Icons.account_circle),
//           title: const Text('Account'),
//           onTap: () {
//             Navigator.pushNamed(context, AccountPage.routeName, arguments: {
//               'currUsername': widget.username,
//               'currProfilePic': widget.profilePic
//             });
//           },
//         ),
//         ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pushNamed(context, AccountSettingsPage.routeName);
//             }),
//         ListTile(
//           leading: const Icon(Icons.star),
//           title: const Text('Subscribe'),
//           onTap: () {
//             Navigator.pop(context);
//             Navigator.push(context, SubscribeOverlay());
//           },
//         ),
//         ListTile(
//           leading: const Icon(Icons.book),
//           title: const Text('Offline Mode'),
//           onTap: () {},
//         ),
//         ListTile(
//           leading: const Icon(Icons.bookmark),
//           title: const Text('Bookmarks'),
//           onTap: () {},
//         ),
//         _buildAuthTile(auth),
//       ],
//     );
//   }

//   Widget _buildAuthTile(FirebaseAuth auth) {
//     return widget.email != null
//         ? ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () {
//               auth.signOut();
//               SharedPreferences.getInstance()
//                   .then((preferences) => preferences.clear());
//               Navigator.of(context).pushNamed(LoginPage.routeName);
//             })
//         : ListTile(
//             leading: const Icon(Icons.login),
//             title: const Text('Login'),
//             onTap: () {
//               Navigator.of(context).pushNamed(LoginPage.routeName);
//             });
//   }
// }
