import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/manga_page/widgets/summary.dart';
import 'package:mangaapp/pages/display_manga.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:mangaapp/widgets/read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/app_constants.dart';

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

  List<Widget> chapters = [];
  @override
  void initState() {
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
                    arguments: {
                      'chapter': chapter.data(),
                      'title': widget.manga['title']
                    });
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
    return Scaffold(
      body: buildPortrait(context, widget.manga),
    );
    // body: OrientationBuilder(builder: ((context, orientation) {
    //   return orientation == Orientation.portrait
    //       ? buildPortrait(context, widget.manga)
    //       : buildLandscape(context, widget.manga);
    // })),
  }

  Widget buildPortrait(BuildContext context, Map<String, dynamic> manga) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 1.sh,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: 150,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                    color: MuhngaColors.black),
                child: Padding(
                    padding: EdgeInsets.only(left: 18.w, right: 18.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 300),
                        Summary(manga),
                        ...chapters,
                      ],
                    )),
              ),
            ),
            Positioned(top: 0, child: buildCover(manga))
          ],
        ),
      ),
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
            Expanded(child: ListView(children: [Summary(manga), ...chapters])),
            // SizedBox(width: 16.w)
          ],
        ),
      ),
    );
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
}
