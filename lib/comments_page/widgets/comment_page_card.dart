import 'package:flutter/material.dart';
import '../../manga_reader_page/widgets/vote_widget.dart';
import '../../shared/muhnga_colors.dart';

class CommentPageCard extends StatefulWidget {
  const CommentPageCard({super.key});

  @override
  State<CommentPageCard> createState() => _CommentPageCardState();
}

class _CommentPageCardState extends State<CommentPageCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            print('hi');
            // Navigator.pushNamed(context, CommentsPage.routeName);
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
        const Divider(color: MuhngaColors.grey, thickness: 0.25),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
