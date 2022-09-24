import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/widgets/emote_button.dart';
import 'package:mangaapp/manga_reader_page/widgets/emote_button_bar.dart';

class PostChapterSurvey extends StatelessWidget {
  const PostChapterSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    const int numResponses = 69;
    return Column(children: [
      Text(
        '$numResponses responses',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const Expanded(child: EmoteButtonBar()),
    ]);
  }
}
