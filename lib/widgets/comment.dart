import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final String profileUrl;
  final String comment;
  final String username;
  final int upvotes;
  final int downvotes;
  const Comment(
      {Key? key,
      required this.profileUrl,
      required this.comment,
      required this.username,
      required this.upvotes,
      required this.downvotes})
      : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(widget.profileUrl)),
      title: Text(widget.username),
      subtitle: Wrap(children: [
        Text(widget.comment, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(
          'Read 5 replies',
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ]),
      trailing: Column(
        children: [
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: const Icon(Icons.keyboard_arrow_up)),
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: const Icon(Icons.keyboard_arrow_down))
        ],
      ),
      onTap: () {},
    );
  }
}
