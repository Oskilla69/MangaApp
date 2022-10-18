import 'package:flutter/material.dart';
import 'comment_section.dart';
import '../../shared/comment_box.dart';
import '../widgets/emote_button_bar.dart';

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
        SliverToBoxAdapter(child: CommentBox()),
        SliverToBoxAdapter(
          child: Text(
            '69 responses',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        // EmoteButtonBar(),
        const CommentSection(),
      ],
    );
  }
}
