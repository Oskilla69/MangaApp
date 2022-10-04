import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'carousel_manga.dart';
import '../widgets/manga_scrollview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Landing extends StatelessWidget {
  Landing({Key? key}) : super(key: key);
  final _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final query = _supabase.from("manga_core").select('''
      id,
      title,
      cover,
      avg_ratings,
      num_ratings
    ''').order("latest_update", ascending: false);
    const width = 180.0;
    const height = 304.0;
    return Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    "What's hot",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: CarouselManga(query)),
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "What's new",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            MangaScrollView(query, width, height, buildEmpty)
          ],
        )
        // ListView(
        //   children: [
        //     Center(
        //       child: Padding(
        //         padding: const EdgeInsets.only(bottom: 24.0),
        //         child: Text(
        //           "What's hot",
        //           style: Theme.of(context).textTheme.titleLarge,
        //         ),
        //       ),
        //     ),
        //     CarouselManga(query),
        //     Center(
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 18.0),
        //         child: Text(
        //           "What's new",
        //           style: Theme.of(context).textTheme.titleLarge,
        //         ),
        //       ),
        //     ),
        //     CustomScrollView(
        //         slivers: [MangaScrollView(query, width, height, buildEmpty)])
        //   ],
        // )
        // child: FirestoreQueryBuilder<Map<String, dynamic>>(
        //     query: query,
        //     builder: (context, snapshot, _) {
        //       if (snapshot.isFetching) {
        //         return const Center(child: CircularProgressIndicator());
        //       } else if (snapshot.hasError) {
        //         print(snapshot.error);
        //         return const Text('An error has occurred.');
        //       } else if (snapshot.docs.isEmpty) {
        //         return const Text('An error has occurred.');
        //       }
        //       return ListView(children: [
        //         Center(
        //           child: Padding(
        //             padding: const EdgeInsets.only(bottom: 24.0),
        //             child: Text(
        //               "What's hot",
        //               style: Theme.of(context).textTheme.titleLarge,
        //             ),
        //           ),
        //         ),
        //         CarouselManga(query),
        //         Center(
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 18.0),
        //             child: Text(
        //               "What's new",
        //               style: Theme.of(context).textTheme.titleLarge,
        //             ),
        //           ),
        //         ),
        //         MangaScrollView(query, width, height, buildEmpty),
        //         GridView.builder(
        //             physics: const NeverScrollableScrollPhysics(),
        //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                 crossAxisCount: (1.sw / width).round(),
        //                 crossAxisSpacing: 16,
        //                 mainAxisSpacing: 16,
        //                 childAspectRatio: width / height),
        //             itemCount: snapshot.docs.length,
        //             padding: const EdgeInsets.all(16),
        //             itemBuilder: (context, index) {
        //               // print(snapshot.docs.length);
        //               if (snapshot.hasMore &&
        //                   index + 1 == snapshot.docs.length) {
        //                 print(snapshot.docs.length);
        //                 snapshot.fetchMore();
        //               }
        //               final manga = snapshot.docs[index].data();
        //               return GestureDetector(
        //                 onTap: () {
        //                   Navigator.pushNamed(context, MangaPage.routeName,
        //                       arguments: manga);
        //                 },
        //                 child: MangaCard(manga, width, height),
        //               );
        //             }),
        //       ]);
        //     })
        );
  }

// ListView(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 24.0),
//               child: Text(
//                 "What's hot",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//           ),
//           CarouselManga(query),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 18.0),
//               child: Text(
//                 "What's new",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//           ),
//           MangaScrollView(query, width, height, buildEmpty),
//         ],
//       ),
  Widget buildEmpty(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
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
      ),
    );
  }
}
