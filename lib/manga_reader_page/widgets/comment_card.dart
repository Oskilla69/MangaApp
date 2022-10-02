import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/comments_page/screens/comments_page.dart';
import 'package:mangaapp/manga_reader_page/widgets/vote_widget.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "username",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, CommentsPage.routeName);
          },
          child: const Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          ),
        ),
        Row(
          children: [
            Text(
              "21/Jan/2022",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: MuhngaColors.grey),
            ),
            const Spacer(),
            const VoteWidget()
          ],
        ),
        const Divider(color: MuhngaColors.grey, thickness: 0.25)
      ],
    );
  }
}
