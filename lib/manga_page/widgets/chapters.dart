import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mangaapp/manga_page/widgets/chapter_tile.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class ChapterWidget extends StatefulWidget {
  const ChapterWidget(this.data, this.scrollableThreshold, this.tileHeight,
      {super.key});
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;
  final int scrollableThreshold;
  final double tileHeight;

  @override
  State<ChapterWidget> createState() => ChapterWidgetState();
}

class ChapterWidgetState extends State<ChapterWidget> {
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> visibleData;
  @override
  void initState() {
    setState(() {
      visibleData = widget.data;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
              fillColor: MuhngaColors.grey,
              filled: true,
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 3, color: MuhngaColors.contrast),
                  borderRadius: BorderRadius.circular(20)),
              hintText: 'Search a Chapter',
              hintStyle: const TextStyle(color: MuhngaColors.secondary)),
          style: const TextStyle(color: MuhngaColors.primary),
          maxLength: 6,
          onChanged: (value) {
            setState(() {
              visibleData = widget.data
                  .where((element) =>
                      element.data()['chapter'].toString().contains(value))
                  .toList();
            });
          },
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: visibleData.length / (1.sw / 400).round() >
                  widget.scrollableThreshold
              ? widget.scrollableThreshold * widget.tileHeight
              : (visibleData.length / (1.sw / 400).round()).ceil() *
                  widget.tileHeight,
          child: GridView.count(
              physics: visibleData.length / (1.sw / 400).round() >
                      widget.scrollableThreshold
                  ? const ScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              crossAxisCount: (1.sw / 400).round(),
              childAspectRatio: 400 / 80,
              children: visibleData.reversed.map((chapter) {
                return ChapterTile(chapter);
              }).toList()),
          // child: GridView.builder(
          //     // crossAxisCount: (1.sw / 300).round(),
          //     // maxCrossAxisExtent: 400,
          //     itemCount: snapshot.data!.docs.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return ChapterTile(snapshot.data!.docs.reversed
          //           .toList()[index]['chapter']);
          //     },
          //     gridDelegate:
          //         SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: (1.sw / 300).round(),
          //     )),
        ),
      ],
    );
    ;
  }
}
