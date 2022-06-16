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
import 'package:mangaapp/pages/search_page.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/widgets/side_menu.dart';
import 'manga_page.dart';
import 'package:http/http.dart' as http;

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

  var mangas = [];
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    appendManga();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('loading...');
        appendManga();
      }
    });
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
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
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // pushMangaData();
    // // Height (without SafeArea)
    // var padding = MediaQuery.of(context).viewPadding;
    // double no = height - padding.top - padding.bottom;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loggedInUser == null) {
        ScaffoldState().showBottomSheet((context) => BottomSheet(
            onClosing: () {},
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Center(
                        child: Text(
                          'Welcome to MangaApp',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(40),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Center(
                        child: Text(
                          'Please login to continue',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
        // ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        //     content: Text('Please sign in/sign up for the best experience.'),
        //     actions: [
        //       TextButton(
        //           onPressed: () {
        //             Navigator.pushNamed(context, LoginPage.routeName);
        //             ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        //           },
        //           child: Text('Sign In/Up')),
        //       TextButton(
        //           onPressed: () {
        //             ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        //           },
        //           child: Text('Close'))
        //     ]));
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manga App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // print('clicked search!');
                showSearch(context: context, delegate: SearchPageDelegate());
              },
            ),
          ],
        ),
        drawer: const SideMenu(),
        body: const InfiniteScrollGrid(sortby: 'last_updated')
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
                      return Icon(
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
