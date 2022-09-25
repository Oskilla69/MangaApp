import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/screens/comment_section.dart';
import 'package:mangaapp/shared/comment_box.dart';
import 'package:mangaapp/manga_reader_page/widgets/emote_button_bar.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: const [
    //     CommentBox(),
    //     Expanded(child: PostChapterSurvey()),
    //     Expanded(child: CommentSection())
    //   ],
    // );
    return CustomScrollView(
      // physics: NeverScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: CommentBox()),
        SliverToBoxAdapter(
          child: Text(
            '69 responses',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const EmoteButtonBar(),
        const CommentSection(),
      ],
    );
  }
}
