import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/manga_reader_page/screens/manga_reader_page.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/muhnga_constants.dart';

class MangaSummary extends StatefulWidget {
  const MangaSummary(this.manga, {Key? key}) : super(key: key);
  final Map<String, dynamic> manga;

  @override
  State<MangaSummary> createState() => _MangaSummaryState();
}

class _MangaSummaryState extends State<MangaSummary> {
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
                Navigator.pushNamed(context, MangaReader.routeName, arguments: {
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
    return buildPortrait(context, widget.manga);
    // body: OrientationBuilder(builder: ((context, orientation) {
    //   return orientation == Orientation.portrait
    //       ? buildPortrait(context, widget.manga)
    //       : buildLandscape(context, widget.manga);
    // })),
  }

  Widget buildPortrait(BuildContext context, Map<String, dynamic> manga) {
    return Column(children: [
      SizedBox(
        width: .9.sw,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: MuhngaColors.secondary,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Text(manga['title'],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBarIndicator(
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: MuhngaColors.star,
                        );
                      },
                      rating: manga['rating'],
                      itemSize: 24),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(manga['rating'].toString()),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('(need count)')
                ],
              ),
              const Divider(
                  color: MuhngaColors.grey, thickness: 0.25, height: 36),
              Text(manga['synopsis']),
              const Divider(
                color: MuhngaColors.grey,
                thickness: 0.25,
                height: 36,
              ),
              buildMiscInformation(manga)
            ]),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Material(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: MuhngaColors.secondary,
              child: SizedBox(
                height: 50.w,
                width: 50.w,
                child: IconButton(
                    onPressed: () {
                      print("favourite clicked");
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 25.0.w,
                      color: MuhngaColors.heartRed,
                    )),
              ),
            ),
            const Spacer(),
            Container(
                height: 50.w,
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                decoration: const BoxDecoration(
                    color: MuhngaColors.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Center(
                  child: Text(
                    "6 Chapters",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )),
            const Spacer(),
            Material(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: MuhngaColors.contrast,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                onTap: () {
                  print('read now clicked');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: SizedBox(
                      height: 50.w,
                      child: Center(
                        child: Text(
                          "Read Now",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .apply(color: MuhngaColors.black),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  // Widget buildLandscape(BuildContext context, Map<String, dynamic> manga) {
  //   return SafeArea(
  //     child: Padding(
  //       padding: EdgeInsets.only(top: 16.h),
  //       child: Row(
  //         children: [
  //           SizedBox(
  //             height: 0.8.sh,
  //             child: buildCover(manga),
  //           ),
  //           SizedBox(width: 16.w),
  //           Expanded(child: ListView(children: [Summary(manga), ...chapters]))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildMiscInformation(Map<String, dynamic> manga) {
    return GridView.extent(
      maxCrossAxisExtent: 300,
      childAspectRatio: 300 / 100,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AUTHOR',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(color: MuhngaColors.grey),
              ),
              Text(manga['author'], textAlign: TextAlign.left),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PUBLISHER',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(color: MuhngaColors.grey),
              ),
              Text(manga['status'], textAlign: TextAlign.left),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STATUS',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(color: MuhngaColors.grey),
                textAlign: TextAlign.left,
              ),
              buildStatusString(context, manga['status'])
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStatusString(BuildContext context, String status) {
    if (status.toLowerCase() == "completed") {
      return Text(
        status,
        style: const TextStyle(color: MuhngaColors.success),
        // style: Theme.of(context)
        //     .textTheme
        //     .bodySmall!
        //     .apply(color: MuhngaColors.success),
      );
    }
    return Text(status);
  }
}
