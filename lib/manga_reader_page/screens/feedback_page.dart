import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/widgets/comment_box.dart';
import 'package:mangaapp/manga_reader_page/widgets/emote_button_bar.dart';
import 'package:mangaapp/manga_reader_page/widgets/post_chapter_survey.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [CommentBox(), Expanded(child: PostChapterSurvey())],
    );
  }
  // return const CustomScrollView(
  //     physics: NeverScrollableScrollPhysics(),
  //     slivers: [
  //       SliverToBoxAdapter(child: CommentBox()),
  //       EmoteButtonBar(),
  //     ],
  //   );
}
