import 'package:flutter/material.dart';
import '../../shared/muhnga_colors.dart';

class VoteWidget extends StatefulWidget {
  const VoteWidget({super.key});

  @override
  State<VoteWidget> createState() => _VoteWidgetState();
}

class _VoteWidgetState extends State<VoteWidget> {
  Color buttonColor = MuhngaColors.grey;
  bool upvoteTapped = false;
  bool downvoteTapped = false;
  int upvotes = 123;
  int downvotes = 5;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
            onPressed: () {
              setState(() {
                upvoteTapped = !upvoteTapped;
                if (upvoteTapped) {
                  upvotes += 1;
                } else if (!upvoteTapped) {
                  upvotes -= 1;
                }

                if (downvoteTapped) {
                  downvotes -= 1;
                }
                downvoteTapped = false;
              });
            },
            style: TextButton.styleFrom(
                foregroundColor:
                    upvoteTapped ? MuhngaColors.contrast : buttonColor),
            icon: const Icon(Icons.keyboard_arrow_up),
            label: Text(upvotes.toString())),
        TextButton.icon(
            onPressed: () {
              setState(() {
                downvoteTapped = !downvoteTapped;
                if (downvoteTapped) {
                  downvotes += 1;
                } else if (!downvoteTapped) {
                  downvotes -= 1;
                }

                if (upvoteTapped) {
                  upvotes -= 1;
                }
                upvoteTapped = false;
              });
            },
            style: TextButton.styleFrom(
                foregroundColor:
                    downvoteTapped ? MuhngaColors.contrast : buttonColor),
            icon: const Icon(Icons.keyboard_arrow_down),
            label: Text(downvotes.toString())),
        // VoteButton(123, const Icon(Icons.keyboard_arrow_up)),
        // VoteButton(12, const Icon(Icons.keyboard_arrow_down))
      ],
    );
  }
}

class VoteButton extends StatefulWidget {
  VoteButton(this.count, this.icon, {super.key});
  final Icon icon;
  int count;

  @override
  State<VoteButton> createState() => VoteButtonState();
}

class VoteButtonState extends State<VoteButton> {
  Color buttonColor = MuhngaColors.grey;
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          setState(() {
            tapped = !tapped;
            buttonColor = tapped ? MuhngaColors.contrast : MuhngaColors.grey;
            widget.count += tapped ? 1 : -1;
          });
        },
        style: TextButton.styleFrom(foregroundColor: buttonColor),
        icon: widget.icon,
        label: Text(widget.count.toString()));
  }
}
