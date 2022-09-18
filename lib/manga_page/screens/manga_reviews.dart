import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mangaapp/manga_page/widgets/review_card.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class MangaReviews extends StatelessWidget {
  const MangaReviews(this.manga, {super.key});
  final Map<String, dynamic> manga;

  @override
  Widget build(BuildContext context) {
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
      SizedBox(
        height: 108,
        child: ListView(scrollDirection: Axis.horizontal, children: const [
          ReviewCard(),
          ReviewCard(),
          ReviewCard(),
          ReviewCard()
        ]),
      ),
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
