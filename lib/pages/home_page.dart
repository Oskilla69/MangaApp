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
import 'package:mangaapp/components/home_page_grid.dart';
import 'package:mangaapp/helpers/app_constants.dart';
import 'package:mangaapp/pages/search_page.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/widgets/side_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manga_page.dart';

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
            .where('email', isEqualTo: loggedInUser?.email)
            .get()
            .then((value) {
          userData = value.docs[0].data();
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void pushMangaData() {
    rootBundle.loadString('assets/manga_data.json').then((data) async {
      var covers = [
        'gs://mangaapp-7bb62.appspot.com/One_Piece,_Volume_61_Cover_(Japanese).jpeg',
        'gs://mangaapp-7bb62.appspot.com/Tokyo_Ghoul_volume_1_cover.jpeg',
        'gs://mangaapp-7bb62.appspot.com/525.jpeg'
      ];
      for (var manga in json.decode(data)) {
        _firestore.collection('manga').doc(manga['title']).set({
          'author': manga['author'],
          'rating': double.parse(manga['rating']),
          'synopsis': manga['synopsis'],
          'title': manga['title'],
          'status': manga['status'],
          'genre': manga['genre'],
          'views': manga['views'],
          'last_updated': DateTime.parse(manga['last_updated']),
          'cover': await _storage
              .refFromURL(covers[Random().nextInt(3)])
              .getDownloadURL()
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
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_001.png?alt=media&token=647659a7-d17f-4206-9b65-5f322a0620e4",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_002.png?alt=media&token=6163bf0c-610c-4adb-9fa5-631c127e4f32",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_003.png?alt=media&token=28826eb0-4558-42fb-afd6-26862b49e386",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_004.png?alt=media&token=1af5bc54-7ffa-4d4c-adc9-898e09219354",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_005.png?alt=media&token=00fa95ab-f438-498e-b286-02cd42ae668b",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_006.png?alt=media&token=53a7c949-3afd-415b-85d8-3b02d730a674",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_007.png?alt=media&token=882cb9b7-27ea-4e25-812a-8d77eb930920",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_008.png?alt=media&token=89cf9e6a-ebee-47e6-96a7-2150c9919d43",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_1051_tcb_009v2.png?alt=media&token=98207459-3207-4c3b-a094-923254aec1f2",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_010.png?alt=media&token=647e27b3-118a-4764-9b8c-44c096774888",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_011.png?alt=media&token=c2996f1f-48fd-4fe8-8a9c-d4b3b83141e0",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_012.png?alt=media&token=214299da-7d5a-4103-8d0d-b7c5889a5f3e",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_013.png?alt=media&token=c31341a8-8a67-4387-b79e-1da068f2296a",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_014.png?alt=media&token=f368d43f-e7ae-4cb8-af50-10da92f585b0",
              "https://firebasestorage.googleapis.com/v0/b/mangaapp-7bb62.appspot.com/o/test%2Fop_tcb_1052morning_015.png?alt=media&token=7cc4b518-bd45-4e72-adb8-e4282ddcdf75",
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Manga App'),
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
          drawer: userData == null
              ? const SideMenu()
              : SideMenu(
                  email: userData!['email'],
                  username: userData!['username'] ?? '',
                ),
          body: TabBarView(children: [
            const InfiniteScrollGrid(mode: 'home'),
            userData != null
                ? InfiniteScrollGrid(
                    mode: 'bookmarks',
                    bookmarks: userData!['bookmarks'],
                  )
                : Center(
                    child: TextButton(
                    child: const Text('Login to get access to bookmarks.'),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                  ))
          ])
          // body: OrientationBuilder(builder: (context, orientation) {
          //   List<Widget> mangaGrid = _buildMangaGrid(orientation);
          //   return GridView.count(
          //       controller: scrollController,
          //       crossAxisCount: orientation == Orientation.portrait
          //           ? (1.sw / 200.w).round()
          //           : (1.sw / 120.w).round(),
          //       childAspectRatio: orientation == Orientation.portrait
          //           ? 460.w / 690.h
          //           : 360.w / 1669.h,
          //       children: mangaGrid);
          ),
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
