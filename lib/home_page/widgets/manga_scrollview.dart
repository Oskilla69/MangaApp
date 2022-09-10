import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:mangaapp/home_page/widgets/manga_card.dart';
import 'package:mangaapp/pages/manga_page.dart';

class MangaScrollView extends StatelessWidget {
  const MangaScrollView(this.query, this.width, this.height, this.emptyResponse,
      {Key? key})
      : super(key: key);
  final Query<Map<String, dynamic>> query;
  final double width;
  final double height;
  final Widget Function(BuildContext context) emptyResponse;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Map<String, dynamic>>(
        query: query,
        builder: (context, snapshot, _) {
          if (snapshot.docs.isEmpty) {
            return emptyResponse(context);
          }
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('An error has occurred.');
          }
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (1.sw / width).round(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: width / (height)),
              itemCount: snapshot.docs.length,
              padding: const EdgeInsets.all(16),
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
                  child: MangaCard(manga, width, height),
                );
              });
        });
  }
}
