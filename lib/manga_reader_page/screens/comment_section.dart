import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/manga_reader_page/widgets/comment_card.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

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
