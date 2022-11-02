import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/home_page/widgets/manga_card.dart';
import 'package:mangaapp/manga_page/screens/manga_page.dart';
import '../widgets/manga_scrollview.dart';
import '../../providers/profile_model.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';

class Favourites extends StatelessWidget {
  Favourites({Key? key}) : super(key: key);
  final _supabase = Supabase.instance.client;
  final mangaDataLocation = "manga_core";

  final width = 180.0;
  final height = 304.0;

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        provider.Provider.of<ProfileModel>(context, listen: true);
    if (profileProvider.favourites.isEmpty) {
      return buildEmptyFavourites(context);
    }
    // final query = _firestore
    //     .collection('manga')
    //     .where("title", whereIn: profileProvider.favourites)
    //     .orderBy('last_updated', descending: true);
    print('asd');
    final query = _supabase
        .from("favourites")
        .select('''
      $mangaDataLocation(
      id,
      title,
      cover,
      avg_ratings,
      num_ratings)
    ''')
        .eq("user", _supabase.auth.currentUser!.id)
        .order("latest_update",
            ascending: false, foreignTable: mangaDataLocation);
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                "Favorites",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
        MangaScrollView(query, width, height, buildEmptyFavourites,
            (context, dynamic manga, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, MangaPage.routeName,
                  arguments: manga[mangaDataLocation]);
            },
            child: MangaCard(manga[mangaDataLocation], width, height),
          );
        })
      ]),
    );
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
