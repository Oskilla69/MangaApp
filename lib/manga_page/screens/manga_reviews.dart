import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mangaapp/manga_page/widgets/review_card.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MangaReviews extends StatelessWidget {
  MangaReviews(this.manga, {super.key});
  final _supabase = Supabase.instance.client;
  final Map<String, dynamic> manga;

  @override
  Widget build(BuildContext context) {
    Future<PostgrestResponse<dynamic>> future =
        _supabase.from("reviews").select().eq("manga", manga['id']).execute();
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reviews",
                  style: Theme.of(context).textTheme.titleMedium,
                  // textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                        itemBuilder: (context, index) {
                          return const Icon(
                            Icons.star,
                            color: MuhngaColors.star,
                          );
                        },
                        rating: manga['avg_ratings'].toDouble(),
                        itemSize: 24),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(manga['avg_ratings'].toString()),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('(${manga["avg_ratings"]} reviews)')
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Text("Show all",
                style: TextStyle(decoration: TextDecoration.underline))
          ],
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      FutureBuilder(
          future: future,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: 108,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      ReviewCard(),
                      ReviewCard(),
                      ReviewCard(),
                      ReviewCard()
                    ]),
              );
            }
            return const SizedBox(
              height: 108,
              child: Center(child: CircularProgressIndicator()),
            );
          })),
      const SizedBox(
        height: 20.0,
      ),
      // Expanded(
      //   child: ListView(
      //     children: [ReviewCard(), ReviewCard(), ReviewCard()],
      //   ),
      // ),

      // Expanded(
      //   child: CarouselSlider.builder(
      //       itemCount: 4,
      //       itemBuilder: ((context, index, realIndex) {
      //         return MangaReviews();
      //       }),
      //       options: CarouselOptions()),
      // )
    ]);
  }
}
