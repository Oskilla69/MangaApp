import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class MuhngaRatingBar extends StatelessWidget {
  const MuhngaRatingBar(this.rating, this.size, {super.key});
  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
        itemBuilder: (context, index) {
          return const Icon(
            Icons.star,
            color: MuhngaColors.star,
          );
        },
        rating: 4.5,
        itemSize: 24);
  }
}
