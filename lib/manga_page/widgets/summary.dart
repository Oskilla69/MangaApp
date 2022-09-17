import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:mangaapp/widgets/read_more.dart';

class Summary extends StatelessWidget {
  const Summary(this.manga, {Key? key}) : super(key: key);
  final Map<String, dynamic> manga;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .9.sw,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: MuhngaColors.secondary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Text(manga['title'],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            const Divider(color: MuhngaColors.grey, thickness: 1),
            Text('Author - ${manga['author']}', textAlign: TextAlign.left),
            Text('Status - ${manga['status']}', textAlign: TextAlign.left),
            Text(manga['synopsis'])
          ]),
        ),
      ),
    );
  }
}
