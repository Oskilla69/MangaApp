import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/carousel_manga_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarouselManga extends StatelessWidget {
  const CarouselManga(this.query, {Key? key}) : super(key: key);
  final PostgrestTransformBuilder query;
  final double carouselWidth = 220;
  final double carouselHeight = 372;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostgrestResponse<dynamic>>(
        future: query.range(0, 10).execute(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return CarouselSlider.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index, realIndex) {
                  return CarouselMangaCard(snapshot.data!.data[index],
                      carouselWidth, carouselHeight);
                },
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    height: carouselHeight,
                    autoPlay: true,
                    viewportFraction: carouselWidth / 1.sw));
          } else if (snapshot.hasError) {
            return const Center(child: Text("There is an error"));
          } else {
            return SizedBox(
                height: carouselHeight,
                child: const Center(child: CircularProgressIndicator()));
          }
        }));
  }
}
