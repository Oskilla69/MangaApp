import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:mangaapp/home_page/screens/bookmarks.dart';
import 'package:mangaapp/home_page/screens/landing.dart';
import 'package:mangaapp/pages/search_page.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:mangaapp/widgets/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/manga_page.dart';

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

  var mangas = [];
  User? loggedInUser;

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

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileModel>(context, listen: true);

    profileProvider.setEmail(userData?['email'] ?? '', false);
    profileProvider.setUsername(userData?['username'] ?? '', false);
    profileProvider.setProfilePic(
        userData?['profile_image'] ?? 'assets/images/logo.jpeg', false);
    profileProvider.addBookmarks(userData?['bookmarks'] ?? [], false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchPageDelegate());
                },
              ),
            ],
            bottom: const TabBar(tabs: [
              Tab(child: Text('Home')),
              Tab(child: Text('Bookmarks'))
            ]),
          ),
          drawer: SideMenu(),
          body: TabBarView(children: [
            Landing(),
            userData != null
                ? Bookmarks()
                : Center(
                    child: TextButton(
                    child: const Text(
                      'Login to get access to bookmarks.',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                  ))
          ])),
    );
  }

  List<Widget> _buildMangaGrid(orientation) {
    List<Widget> mangaGrid = [
      ...mangas.map((manga) {
        return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, MangaPage.routeName,
                  arguments: manga);
            },
            child: Card(
              margin: EdgeInsets.all(0.025.sh),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  FutureBuilder(
                    future:
                        _storage.refFromURL(manga['cover']).getDownloadURL(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data!,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress)),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: orientation == Orientation.portrait
                              ? 180.h
                              : 420.h,
                          width: orientation == Orientation.portrait
                              ? 180.w
                              : 120.w,
                          alignment: FractionalOffset.topCenter,
                        );
                      } else if (snapshot.connectionState ==
                              ConnectionState.waiting ||
                          !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const Text('Error');
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.9, left: 1.69),
                    child: Text(
                      manga['title'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  RatingBarIndicator(
                    itemBuilder: (context, index) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    rating: manga['rating'],
                    itemSize: orientation == Orientation.portrait ? 22.h : 11.w,
                  ),
                ],
              ),
            ));
      }).toList()
    ];

    if (hasMore) {
      mangaGrid.add(const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      ));
    }

    return mangaGrid;
  }
}
