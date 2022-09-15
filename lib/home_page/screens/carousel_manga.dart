import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:mangaapp/home_page/widgets/carousel_manga_card.dart';

class CarouselManga extends StatelessWidget {
  const CarouselManga(this.query, {Key? key}) : super(key: key);
  final Query<Map<String, dynamic>> query;
  final double carouselWidth = 220;
  final double carouselHeight = 372;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Map<String, dynamic>>(
        query: query,
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('An error has occurred.');
          } else if (snapshot.docs.isEmpty) {
            return const Text('An error has occurred.');
          } else {
            return CarouselSlider.builder(
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index, realIndex) {
                  return CarouselMangaCard(snapshot.docs[index].data(),
                      carouselWidth, carouselHeight);
                },
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    height: carouselHeight,
                    autoPlay: true,
                    viewportFraction: carouselWidth / 1.sw));
          }
        });
  }
}
