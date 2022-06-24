import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/pages/display_manga.dart';
import 'package:mangaapp/widgets/read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/app_constants.dart';

class MangaSummary extends StatefulWidget {
  // const MangaSummary({Key? key}) : super(key: key);
  MangaSummary(this.manga, {Key? key}) : super(key: key);
  Map<String, dynamic> manga;

  @override
  State<MangaSummary> createState() => _MangaSummaryState();
}

class _MangaSummaryState extends State<MangaSummary> {
  final _storage = FirebaseStorage.instance;

  final _firestore = FirebaseFirestore.instance;
  bool dataSaver = false;
  // List<QueryDocumentSnapshot<Map<String, dynamic>>> chapters = [];

  List<Widget> chapters = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore
        .collection('manga')
        .doc(widget.manga['title'])
        .collection('chapters')
        .get()
        .then(
      (value) {
        setState(() {
          chapters = value.docs.map((chapter) {
            return ListTile(
              leading: const Icon(Icons.remove),
              title: Text('Chapter ${chapter['chapter']}'),
              onTap: () {
                Navigator.pushNamed(context, DisplayManga.routeName,
                    arguments: chapter.data());
              },
            );
          }).toList();
        });
      },
    );
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dataSaver = prefs.getBool(SHARED_PREFERENCES.DATA_SAVER.parse()) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: ((context, orientation) {
      return orientation == Orientation.portrait
          ? buildPortrait(context, widget.manga)
          : buildLandscape(context, widget.manga);
    }));
  }

  Widget showChapters(Map<String, dynamic> manga) {
    return FutureBuilder(
        future: _firestore
            .collection('manga')
            .doc(manga['title'])
            .collection('chapters')
            .get(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return Column(
                // shrinkWrap: true,
                children: snapshot.data!.docs.map((chapter) {
              return ListTile(
                title: Text('Chapter ${chapter['chapter']}'),
              );
            }).toList());
          }
          return const Center(child: CircularProgressIndicator());
        }));
  }

  Widget buildPortrait(BuildContext context, Map<String, dynamic> manga) {
    return ListView(
      children: [
        buildCover(manga),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Column(
            children: [
              ...buildSummary(context),
            ],
          ),
        ),
        ...chapters,
      ],
    );
  }

  Widget buildLandscape(BuildContext context, Map<String, dynamic> manga) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Row(
          children: [
            SizedBox(
              height: 0.8.sh,
              child: buildCover(manga),
            ),
            SizedBox(width: 16.w),
            Expanded(
                child: ListView(children: [
              ...buildSummary(context).toList(),
              ...chapters
            ])),
            // SizedBox(width: 16.w)
          ],
        ),
      ),
    );
  }

  List<Widget> buildSummary(BuildContext context) {
    return [
      Text('Title - ${widget.manga['title']}',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleLarge),
      Text('Author - ${widget.manga['author']}', textAlign: TextAlign.left),
      Text('Status - ${widget.manga['status']}', textAlign: TextAlign.left),
      ReadMore(
        'Synopsis - ${widget.manga['synopsis']}',
        trimLines: 2,
        colorClickableText: Colors.blue,
        style: Theme.of(context).textTheme.bodyText2,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Show more',
        trimExpandedText: ' Show less',
      ),
      RatingBar.builder(
          itemBuilder: (context, index) {
            return Icon(color: Colors.amber, Icons.star);
          },
          initialRating: widget.manga['rating'],
          minRating: 1,
          itemCount: 5,
          allowHalfRating: true,
          onRatingUpdate: (rating) {
            print('set rating: ' + rating.toString());
          })
    ];
  }

  Widget buildCover(Map<String, dynamic> manga) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CachedNetworkImage(
          imageUrl: manga['cover'],
          fit: BoxFit.contain,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          height: 320.h),
    );
  }

  Widget buildFutureCover(Map<String, dynamic> manga, Orientation orientation) {
    return FutureBuilder(
        future: _storage.refFromURL(manga['cover']).getDownloadURL(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return CachedNetworkImage(
                // TODO: change this to a default image
                imageUrl: snapshot.data ?? '',
                fit: BoxFit.contain,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 360.w,
                height: 440.h);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
