import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/shared/muhnga_app_bar.dart';
import 'package:mangaapp/shared/muhnga_bottom_bar.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:mangaapp/home_page/screens/favourites.dart';
import 'package:mangaapp/home_page/screens/landing.dart';
import 'package:mangaapp/home_page/screens/user_settings.dart';
import 'package:mangaapp/pages/search_page.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:mangaapp/shared/muhnga_icon_button.dart';
import 'package:mangaapp/widgets/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  bool hasMore = true;
  final scrollController = ScrollController();
  final int limit = 10;
  bool dataSaver = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // pushMangaData();
    appendManga();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        appendManga();
      }
    });
    _loadPreferences();

    ChangeNotifierProvider(
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
      return const AccountSettings();
    }
  ];
  static final List<String> displayTitles = [
    'Home',
    'Search',
    'Favorites',
    'Settings'
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

  void pushMangaData() {
    rootBundle.loadString('assets/manga_data.json').then((data) async {
      // var covers = [
      //   'gs://mangaapp-7bb62.appspot.com/One_Piece,_Volume_61_Cover_(Japanese).jpeg',
      //   'gs://mangaapp-7bb62.appspot.com/Tokyo_Ghoul_volume_1_cover.jpeg',
      //   'gs://mangaapp-7bb62.appspot.com/525.jpeg'
      // ];
      for (var manga in json.decode(data)) {
        _firestore.collection('manga').doc(manga['title']).set({
          'author': manga['author'],
          'rating': manga['rating'],
          'synopsis': manga['synopsis'],
          'title': manga['title'],
          'status': manga['status'],
          'genre': manga['genre'],
          'views': manga['views'],
          'cover': await _storage.refFromURL(manga['cover']).getDownloadURL(),
          'last_updated': DateTime.parse(manga['last_updated']),
        });
        for (var i = 1; i < (Random().nextInt(8) + 3); i++) {
          _firestore
              .collection('manga')
              .doc(manga['title'])
              .collection('chapters')
              .doc(i.toString())
              .set({
            'chapter': i,
            'pages': [
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland.png?alt=media&token=2f7ad50b-63c0-4c53-ac8a-c9fb51b4ebfa",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(1).png?alt=media&token=a200219b-0f09-4e1a-9bd5-65766d556add",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(2).png?alt=media&token=6137f729-7721-4020-aba3-a85cd58258fb",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(3).png?alt=media&token=8640029c-1657-48b6-b768-106d688fcab7",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(4).png?alt=media&token=ed88acf9-10bc-466f-88e1-66e1165915e4",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(5).png?alt=media&token=d6933342-8e6d-4db2-b9b0-17c06ffaeee3",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(6).png?alt=media&token=b33d6ad0-7862-4444-8b1b-ce0a3eec95f8",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(7).png?alt=media&token=65dc715d-571f-422c-b0f6-537ac20e24a1",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/demo%2Fdrawisland%20(8).png?alt=media&token=fa06e558-466e-4956-8a81-8644b84da91b"
            ]
          });
        }
      }
    });
  }

  void appendManga() {
    var mangaRef = _firestore.collection('manga');

    mangaRef
        .orderBy('last_updated', descending: true)
        .limit(limit)
        .get()
        .then((res) {
      setState(() {
        mangas.addAll(res.docs.map((manga) => manga.data()));
        if (res.docs.length < limit) {
          hasMore = false;
        }
      });
    });
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
    final profileProvider = Provider.of<ProfileModel>(context, listen: true);

    profileProvider.setEmail(userData?['email'] ?? '', false);
    profileProvider.setUsername(userData?['username'] ?? '', false);
    profileProvider.setProfilePic(
        userData?['profile_image'] ?? 'assets/images/logo.jpeg', false);
    profileProvider.addFavourites(userData?['bookmarks'] ?? [], false);

    return Scaffold(
      drawer: SideMenu(),
      appBar: MuhngaAppBar(displayTitles[currIndex], Builder(
        builder: ((context) {
          return MuhngaIconButton(
              const Icon(Icons.menu), () => Scaffold.of(context).openDrawer());
        }),
      ), [
        MuhngaIconButton(const Icon(Icons.search), () {
          showSearch(context: context, delegate: SearchPageDelegate());
        }),
      ]),
      body: Container(
        child: displays.elementAt(currIndex)(context, userData),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
