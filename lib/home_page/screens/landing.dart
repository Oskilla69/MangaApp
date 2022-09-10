import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:mangaapp/home_page/widgets/manga_card.dart';
import 'package:mangaapp/home_page/widgets/manga_scrollview.dart';
import 'package:mangaapp/pages/manga_page.dart';

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
    return MangaScrollView(query, width, height, buildEmpty);
  }

  Widget buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
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
