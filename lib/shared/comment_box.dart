import 'package:flutter/material.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class CommentBox extends StatelessWidget {
  CommentBox({super.key});
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 360,
        child: TextField(
            controller: commentController,
            decoration: InputDecoration(
                hintText: "Enter a comment",
                border: const OutlineInputBorder(),
                fillColor: MuhngaColors.secondary,
                filled: true,
                suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: (() {
                      print(commentController.text);
                    }))),
            maxLength: 500,
            maxLines: 4));
  }
}
