import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import '../../manga_page/screens/manga_page.dart';

class InfiniteScrollGrid extends StatefulWidget {
  final String sortby;
  final String mode;
  final List<dynamic> bookmarks;

  const InfiniteScrollGrid(
      {Key? key,
      this.sortby = 'last_updated',
      required this.mode,
      this.bookmarks = const []})
      : super(key: key);

  @override
  State<InfiniteScrollGrid> createState() => _InfiniteScrollGridState();
}

class _InfiniteScrollGridState extends State<InfiniteScrollGrid> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return widget.mode == 'home' ? _fetchHomePage() : _fetchBookmarks();
  }

  Widget _fetchBookmarks() {
    if (widget.bookmarks.isEmpty) {
      return buildEmptyBookmarks();
    }
    final query = _firestore
        .collection('manga')
        .where("title", whereIn: widget.bookmarks)
        .orderBy(widget.sortby, descending: true);
    return buildGrid(query);
  }

  Widget _fetchHomePage() {
    final query =
        _firestore.collection('manga').orderBy(widget.sortby, descending: true);
    return buildGrid(query);
  }

  Widget buildEmptyBookmarks() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 0.32.sh),
          Text('No bookmarks yet.',
              style: Theme.of(context).textTheme.titleLarge),
          Text(
            "Come back when you've added some bookmarks!",
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }

  Widget buildGrid(query) {
    return OrientationBuilder(builder: (context, orientation) {
      return FirestoreQueryBuilder<Map<String, dynamic>>(
          query: query,
          builder: (context, snapshot, _) {
            if (snapshot.docs.isEmpty) {
              return buildEmptyBookmarks();
            }
            if (snapshot.isFetching) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Text('An error has occurred.');
            }
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: orientation == Orientation.portrait
                      ? (1.sw / 200.w).round()
                      : (1.sw / 120.w).round(),
                  childAspectRatio: orientation == Orientation.portrait
                      ? 460.w / 669.h
                      : 360.w / 1669.h,
                ),
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    print(snapshot.docs.length);
                    snapshot.fetchMore();
                  }
                  final manga = snapshot.docs[index].data();
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
                });
          });
    });
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
}
