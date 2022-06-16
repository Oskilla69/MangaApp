import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaapp/pages/manga_page.dart';

class InfiniteScrollGrid extends StatefulWidget {
  const InfiniteScrollGrid({Key? key, required String sortby})
      : super(key: key);

  @override
  State<InfiniteScrollGrid> createState() => _InfiniteScrollGridState();
}

class _InfiniteScrollGridState extends State<InfiniteScrollGrid> {
  final _pagingController = PagingController(firstPageKey: 0);
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  final limit = 10;
  String sortby = 'last_updated';

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _fetchPage(int page) {
    try {
      _firestore
          .collection('manga')
          .orderBy(sortby)
          .startAt([page])
          .limit(limit)
          .get()
          .then((res) {
            var newMangas = res.docs.map((manga) => manga.data());
            if (newMangas.length < limit) {
              _pagingController.appendLastPage(newMangas.toList());
            } else {
              _pagingController.appendPage(newMangas.toList(), page + limit);
            }
          });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return PagedGridView(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: ((context, dynamic manga, index) {
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
                          buildCover(manga, orientation),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 6.9, left: 1.69),
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
                            itemSize: orientation == Orientation.portrait
                                ? 22.h
                                : 11.w,
                          ),
                        ],
                      ),
                    ));
              })),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: orientation == Orientation.portrait
                    ? 460.w / 690.h
                    : 360.w / 1669.h,
              ),
            );
          },
        ),
        onRefresh: () => Future.sync(() => _pagingController.refresh()));
  }

  Widget buildCover(Map<String, dynamic> manga, Orientation orientation) {
    return CachedNetworkImage(
      imageUrl: manga['cover'],
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(value: downloadProgress.progress)),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      height: orientation == Orientation.portrait ? 180.h : 420.h,
      width: orientation == Orientation.portrait ? 180.w : 120.w,
      alignment: FractionalOffset.topCenter,
    );
  }

  Widget buildFutureCover(Map<String, dynamic> manga, Orientation orientation) {
    return FutureBuilder(
      future: _storage.refFromURL(manga['cover']).getDownloadURL(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.hasData) {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            height: orientation == Orientation.portrait ? 180.h : 420.h,
            width: orientation == Orientation.portrait ? 180.w : 120.w,
            alignment: FractionalOffset.topCenter,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text('Error');
        }
      },
    );
  }
}
