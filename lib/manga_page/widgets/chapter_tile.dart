import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/screens/manga_reader_page.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class ChapterTile extends StatelessWidget {
  ChapterTile(this.chapter, {super.key});
  final dynamic chapter;
  final Map<String, String> monthStrings = {
    "1": "Jan",
    "2": "Feb",
    "3": "March",
    "4": "April",
    "5": "May",
    "6": "June",
    "7": "July",
    "8": "Aug",
    "9": "Sept",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec"
  };
  @override
  Widget build(BuildContext context) {
    int chapterNumber = chapter['chapter'];
    DateTime date = DateTime.parse(chapter['upload_date']);
    return GestureDetector(
      onTap: () {
        print(chapter);
        Navigator.pushNamed(context, MangaReader.routeName, arguments: {
          'chapter': chapter,
          // 'title': widget.manga['title']
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Chapter ${chapterNumber.toString()}',
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                            '${date.day} ${monthStrings[date.month.toString()]} ${date.year}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .apply(color: MuhngaColors.grey)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.lock)
              ],
            ),
            const Divider(
                color: MuhngaColors.grey, thickness: 0.25, height: 36),
          ],
        ),
      ),
    );
  }
}
