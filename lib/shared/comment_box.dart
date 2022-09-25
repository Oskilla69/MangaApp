import 'package:flutter/material.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class CommentBox extends StatelessWidget {
  const CommentBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 360,
        child: TextField(
            decoration: InputDecoration(
                hintText: "Enter a comment",
                border: const OutlineInputBorder(),
                fillColor: MuhngaColors.secondary,
                filled: true,
                suffixIcon: IconButton(
                    icon: const Icon(Icons.send), onPressed: (() {}))),
            maxLength: 500,
            maxLines: 4));
  }
}
