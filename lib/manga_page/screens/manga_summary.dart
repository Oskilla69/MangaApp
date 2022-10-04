import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/muhnga_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/muhnga_constants.dart';

class MangaSummary extends StatefulWidget {
  const MangaSummary(this.manga, {Key? key}) : super(key: key);
  final Map<String, dynamic> manga;

  @override
  State<MangaSummary> createState() => _MangaSummaryState();
}

class _MangaSummaryState extends State<MangaSummary> {
  final _supabase = Supabase.instance.client;
  bool dataSaver = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dataSaver = prefs.getBool(SHARED_PREFERENCES.DATA_SAVER.parse()) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostgrestResponse<dynamic>>(
      future: _supabase.from("manga_info").select('''
          author, publisher, status, synopsis
        ''').eq("id", widget.manga['id']).limit(1).execute(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> mangaData = snapshot.data!.data[0];
          return buildPortrait(context, {
            'title': widget.manga['title'],
            'avg_ratings': widget.manga['avg_ratings'],
            'num_ratings': widget.manga['num_ratings'],
            'author': mangaData['author'],
            'synopsis': mangaData['synopsis'],
            'publisher': mangaData['publisher'],
            'status': mangaData['status']
          });
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("There has been an error"),
          );
        }
        return SizedBox(
            width: .9.sw,
            height: 300,
            child: const Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                color: MuhngaColors.secondary,
                child: Center(
                  child: CircularProgressIndicator(),
                )));
      },
    );
    // body: OrientationBuilder(builder: ((context, orientation) {
    //   return orientation == Orientation.portrait
    //       ? buildPortrait(context, widget.manga)
    //       : buildLandscape(context, widget.manga);
    // })),
  }

  Widget buildPortrait(BuildContext context, Map<String, dynamic> manga) {
    return Column(children: [
      SizedBox(
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
                      rating: manga['avg_ratings'].toDouble(),
                      itemSize: 24),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(manga['avg_ratings'].toString()),
                  const SizedBox(
                    width: 5,
                  ),
                  Text('(${manga["num_ratings"]} reviews)')
                ],
              ),
              const Divider(
                  color: MuhngaColors.grey, thickness: 0.25, height: 36),
              Text(manga['synopsis']),
              const Divider(
                color: MuhngaColors.grey,
                thickness: 0.25,
                height: 36,
              ),
              buildMiscInformation(manga)
            ]),
          ),
        ),
      ),
    ]);
  }

  // Widget buildLandscape(BuildContext context, Map<String, dynamic> manga) {
  //   return SafeArea(
  //     child: Padding(
  //       padding: EdgeInsets.only(top: 16.h),
  //       child: Row(
  //         children: [
  //           SizedBox(
  //             height: 0.8.sh,
  //             child: buildCover(manga),
  //           ),
  //           SizedBox(width: 16.w),
  //           Expanded(child: ListView(children: [Summary(manga), ...chapters]))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildMiscInformation(Map<String, dynamic> manga) {
    return GridView.extent(
      maxCrossAxisExtent: 300,
      childAspectRatio: 300 / 100,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AUTHOR',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(color: MuhngaColors.grey),
              ),
              Text(manga['author'], textAlign: TextAlign.left),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PUBLISHER',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(color: MuhngaColors.grey),
              ),
              Text(manga['publisher'], textAlign: TextAlign.left),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STATUS',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .apply(color: MuhngaColors.grey),
                textAlign: TextAlign.left,
              ),
              buildStatusString(context, manga['status'])
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStatusString(BuildContext context, String status) {
    if (status.toLowerCase() == "completed") {
      return Text(
        status,
        style: const TextStyle(color: MuhngaColors.success),
        // style: Theme.of(context)
        //     .textTheme
        //     .bodySmall!
        //     .apply(color: MuhngaColors.success),
      );
    } else if (status.toLowerCase() == "hiatus") {
      return Text(
        status,
        style: const TextStyle(color: MuhngaColors.heartRed),
      );
    }
    return Text(status);
  }
}
