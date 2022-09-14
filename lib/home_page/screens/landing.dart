import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/home_page/widgets/manga_scrollview.dart';

class Landing extends StatelessWidget {
  Landing({Key? key}) : super(key: key);
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final query = _firestore
        .collection('manga')
        .orderBy('last_updated', descending: true);
    const width = 180.0;
    const height = 304.0;
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: MangaScrollView(query, width, height, buildEmpty),
    );
  }

  Widget buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(height: 0.32.sh),
            Text("Error!", style: Theme.of(context).textTheme.titleLarge),
            Text(
              "It seems there is no manga at the moment! Please refresh or come back later.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        ),
      ),
    );
  }
}
