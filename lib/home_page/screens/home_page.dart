import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../pages/account_page.dart';
import '../../premium_page/screens/premium_page.dart';
import '../../shared/muhnga_app_bar.dart';
import '../../shared/muhnga_bottom_bar.dart';
import '../../shared/muhnga_constants.dart';
import 'favourites.dart';
import 'landing.dart';
import '../../search_page/screens/search_page.dart';
import '../../login_page/screens/login_page.dart';
import '../../providers/profile_model.dart';
import '../../shared/muhnga_colors.dart';
import '../../shared/muhnga_icon_button.dart';
import '../../widgets/side_menu.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = Supabase.instance.client.auth;
  final _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;
  bool hasMore = true;
  final int limit = 10;
  bool dataSaver = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loadPreferences();

    provider.ChangeNotifierProvider(
      create: ((context) => ProfileModel()),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loggedInUser == null) {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 0.32.sh,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          'Login/Sign up to get access to even more features!',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                          child: const Text('Login/Sign Up'))
                    ]),
              );
            });
      }
    });
  }

  var mangas = [];
  static final List displays = [
    (context, userData) => Landing(),
    () => null,
    (context, userData) {
      return userData != null
          ? Favourites()
          : Center(
              child: TextButton(
              child: const Text(
                'Login to get access to favorites.',
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.routeName);
              },
            ));
    },
    (context, userData) {
      return const PremiumPage();
    }
  ];
  static final List<String> displayTitles = [
    'Home',
    'Search',
    'Favorites',
    'Premium'
  ];
  int currIndex = 0;
  User? loggedInUser;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dataSaver = prefs.getBool(SHARED_PREFERENCES.DATA_SAVER.parse()) ?? false;
    });
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // setState(() async {
        //   loggedInUser = user;
        //   userData = await _firestore
        //       .collection('profile')
        //       .doc(loggedInUser?.email)
        //       .get();
        // });
        loggedInUser = user;
        _firestore
            .collection('profile')
            .doc(loggedInUser?.email)
            .get()
            .then((value) {
          userData = value.data();
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void onIconTapped(int index) {
    if (index == 1) {
      showSearch(
        context: context,
        delegate: SearchPageDelegate(),
      );
    } else {
      setState(() {
        currIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        provider.Provider.of<ProfileModel>(context, listen: true);

    profileProvider.setEmail(userData?['email'] ?? '', false);
    profileProvider.setUsername(userData?['username'] ?? '', false);
    profileProvider.setProfilePic(
        userData?['profile_image'] ?? 'assets/images/logo.jpeg', false);
    profileProvider.addFavourites(userData?['bookmarks'] ?? [], false);

    return Scaffold(
      drawer: SideMenu(),
      appBar: MuhngaAppBar(displayTitles[currIndex], Builder(
        builder: ((context) {
          return MuhngaIconButton(const Icon(Icons.account_circle),
              () => Navigator.pushNamed(context, AccountPage.routeName));
        }),
      ), [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: MuhngaIconButton(const Icon(Icons.notifications), (() {
        //     print('wassup');
        //   })),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MuhngaIconButton(const Icon(Icons.history), (() {
            print('history wassup');
          })),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: MuhngaIconButton(
              SvgPicture.asset(
                'assets/icons/dice.svg',
                height: 24.0,
              ), () {
            showSearch(context: context, delegate: SearchPageDelegate());
          }),
        ),
      ]),
      body: Container(
        child: displays.elementAt(currIndex)(context, userData),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            color: MuhngaColors.black),
      ),
      bottomNavigationBar: MuhngaBottomBar(currIndex, onIconTapped),
    );
  }
}

// class MuhngaAppBar extends StatelessWidget with PreferredSizeWidget {
//   const MuhngaAppBar(
//     this.title, {
//     Key? key,
//   }) : super(key: key);
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 18.0, vertical: (kToolbarHeight - 42) / 2),
//       child: AppBar(
//         title: Text(
//           title,
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         leading: MuhngaIconButton(
//             const Icon(Icons.menu), () => Scaffold.of(context).openDrawer()),
//         actions: [
//           MuhngaIconButton(const Icon(Icons.search), () {
//             showSearch(context: context, delegate: SearchPageDelegate());
//           }),
//         ],
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
