import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/manga_page/widgets/chapter_tile.dart';
import 'package:mangaapp/manga_page/widgets/chapters.dart';
import 'package:mangaapp/shared/muhnga_app_bar.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class MangaChapters extends StatelessWidget {
  MangaChapters(this.manga, {super.key});
  final Map<String, dynamic> manga;
  final _firestore = FirebaseFirestore.instance;
  final scrollableThreshold = 6;
  final tileHeight = 69.0;
  String chapterFilter = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.89.sw,
      decoration: const BoxDecoration(
          color: MuhngaColors.secondary,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "CHAPTERS",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: MuhngaColors.grey),
            ),
            const Divider(
                color: MuhngaColors.grey, thickness: 0.25, height: 36),
            FutureBuilder(
                future: _firestore
                    .collection('manga')
                    .doc(manga['title'])
                    .collection('chapters')
                    .get(),
                builder: ((context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    return ChapterWidget(
                        snapshot.data!.docs, scrollableThreshold, tileHeight);
                  }
                  return const Center(child: CircularProgressIndicator());
                })),
          ],
        ),
      ),
    );
    ;
  }
}
