import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/chapters.dart';
import '../../shared/muhnga_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MangaChapters extends StatelessWidget {
  MangaChapters(this.manga, {super.key});
  final Map<String, dynamic> manga;
  final _supabase = Supabase.instance.client;
  final scrollableThreshold = 6;
  final tileHeight = 69.0;
  String chapterFilter = "";

  @override
  Widget build(BuildContext context) {
    Future<PostgrestResponse<dynamic>> query = _supabase
        .from("chapter")
        .select('''
          id, upload_date, chapter
        ''')
        .eq('manga', manga['id'])
        .order('chapter', ascending: true)
        .execute();
    return FutureBuilder<PostgrestResponse<dynamic>>(
        future: query,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> manga = snapshot.data!.data;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        color: MuhngaColors.secondary,
                        child: SizedBox(
                          height: 50.w,
                          width: 50.w,
                          child: IconButton(
                              onPressed: () {
                                print("favourite clicked");
                              },
                              icon: Icon(
                                Icons.favorite,
                                size: 25.0.w,
                                color: MuhngaColors.heartRed,
                              )),
                        ),
                      ),
                      const Spacer(),
                      Container(
                          height: 50.w,
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          decoration: const BoxDecoration(
                              color: MuhngaColors.secondary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: Center(
                            child: Text(
                              "${manga.length} Chapters",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )),
                      const Spacer(),
                      Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        color: MuhngaColors.contrast,
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          onTap: () {
                            print('read now clicked');
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                            child: SizedBox(
                                height: 50.w,
                                child: Center(
                                  child: Text(
                                    "Read Now",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .apply(color: MuhngaColors.black),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 0.89.sw,
                  decoration: const BoxDecoration(
                      color: MuhngaColors.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "CHAPTERS",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: MuhngaColors.grey),
                        ),
                        const Divider(
                            color: MuhngaColors.grey,
                            thickness: 0.25,
                            height: 36),
                        ChapterWidget(snapshot.data!.data, scrollableThreshold,
                            tileHeight)
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          var display;
          if (snapshot.hasError) {
            display = const Center(
              child: Text("There is an error."),
            );
          } else {
            display = const Center(child: CircularProgressIndicator());
          }
          return Container(
              width: 0.89.sw,
              height: 300,
              decoration: const BoxDecoration(
                  color: MuhngaColors.secondary,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: display);
        }));
  }
}
