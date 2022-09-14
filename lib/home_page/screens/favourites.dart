import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/home_page/widgets/manga_scrollview.dart';
import 'package:mangaapp/providers/profile_model.dart';
import 'package:provider/provider.dart';

class Favourites extends StatelessWidget {
  Favourites({Key? key}) : super(key: key);
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileModel>(context, listen: true);
    if (profileProvider.favourites.isEmpty) {
      return buildEmptyFavourites(context);
    }
    final query = _firestore
        .collection('manga')
        .where("title", whereIn: profileProvider.favourites)
        .orderBy('last_updated', descending: true);
    const width = 180.0;
    const height = 304.0;
    return MangaScrollView(query, width, height, buildEmptyFavourites);
  }

  Widget buildEmptyFavourites(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          children: [
            SizedBox(height: 0.32.sh),
            Text('No favorites yet.',
                style: Theme.of(context).textTheme.titleLarge),
            Text(
              "Come back when you've added some favorites!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        ),
      ),
    );
  }
}