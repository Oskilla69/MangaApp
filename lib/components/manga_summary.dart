import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mangaapp/models/manga.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/widgets/read_more.dart';

class MangaSummary extends StatelessWidget {
  // const MangaSummary({Key? key}) : super(key: key);
  const MangaSummary(this.manga);

  final Manga manga;
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: ((context, orientation) {
      return Container(
        child: Card(
            child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait
              ? (1.sw / 600.w).round()
              : (1.sw / 600.h).round(),
          childAspectRatio: 480.w / 440.w,
          padding: EdgeInsets.only(top: 20.h),
          children: [
            CachedNetworkImage(
                imageUrl: manga.imageUrl,
                fit: BoxFit.contain,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 360.w,
                height: 440.h),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Center(
                child: SizedBox(
                  width: 0.9.sw,
                  child: Column(
                    children: [
                      Text(
                        'Title - ${manga.title}',
                        textAlign: TextAlign.left,
                      ),
                      Text('Author - ${manga.author}',
                          textAlign: TextAlign.left),
                      Text('Status - ${manga.status}',
                          textAlign: TextAlign.left),
                      ReadMore(
                        'Synopsis - ${manga.synopsis}',
                        trimLines: 2,
                        colorClickableText: Colors.blue,
                        style: Theme.of(context).textTheme.bodyText2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: ' Show less',
                      ),
                      // Text('Synopsis - ${manga.synopsis}', textAlign: TextAlign.left),
                      RatingBar.builder(
                          itemBuilder: (context, index) {
                            return Icon(color: Colors.amber, Icons.star);
                          },
                          initialRating: manga.rating,
                          minRating: 1,
                          itemCount: 5,
                          allowHalfRating: true,
                          onRatingUpdate: (rating) {
                            print('set rating: ' + rating.toString());
                          })
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      );
    }));
  }
}
