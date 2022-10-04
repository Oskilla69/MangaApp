import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../shared/muhnga_colors.dart';

class MangaCard extends StatelessWidget {
  const MangaCard(this.manga, this.width, this.height, {Key? key})
      : super(key: key);
  final Map<String, dynamic> manga;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          buildCover(manga),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              manga['title'],
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RatingBarIndicator(
              itemBuilder: (context, index) {
                return const Icon(
                  Icons.star,
                  color: MuhngaColors.star,
                );
              },
              rating: manga['avg_ratings'].toDouble(),
              itemSize: 18),
        ],
      ),
    );
  }

  Widget buildCover(Map<String, dynamic> manga) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CachedNetworkImage(
          imageUrl: manga['cover'],
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          height: height,
          width: width,
          alignment: FractionalOffset.topCenter,
        ),
      ),
    );
  }
}
