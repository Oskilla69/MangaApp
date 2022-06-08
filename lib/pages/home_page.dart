import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/pages/login_page.dart';
import 'package:mangaapp/widgets/side_menu.dart';
import 'manga_page.dart';
import 'package:mangaapp/dummy-data.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    // // Height (without SafeArea)
    // var padding = MediaQuery.of(context).viewPadding;
    // double no = height - padding.top - padding.bottom;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loggedInUser != null) {
        ScaffoldState().showBottomSheet((context) => BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Container(
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
                    Container(
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Center(
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                          child: Text('Login'),
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
                print('clicked search!');
              },
            ),
          ],
        ),
        drawer: const SideMenu(),
        body: OrientationBuilder(builder: (context, orientation) {
          return GridView.count(
              crossAxisCount: orientation == Orientation.portrait
                  ? (1.sw / 200.w).round()
                  : (1.sw / 120.w).round(),
              childAspectRatio: orientation == Orientation.portrait
                  ? 460.w / 690.h
                  : 360.w / 1669.h,
              children: mangas.map((manga) {
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
                          CachedNetworkImage(
                            imageUrl: manga.imageUrl,
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.9),
                            child: Text(manga.title),
                          ),
                          RatingBarIndicator(
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                            rating: manga.rating,
                            itemSize: orientation == Orientation.portrait
                                ? 22.h
                                : 11.w,
                          ),
                        ],
                      ),
                    ));
              }).toList());
        }));
  }
}
