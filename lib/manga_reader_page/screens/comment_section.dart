import 'package:flutter/material.dart';
import '../widgets/comment_card.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        const [
          CommentCard(),
          CommentCard(),
          CommentCard(),
          CommentCard(),
        ],
      ),
    );
  }
}
