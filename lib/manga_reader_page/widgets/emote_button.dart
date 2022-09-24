import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class EmoteButton extends StatefulWidget {
  const EmoteButton(this.emote, this.emoteTitle, this.handleClick,
      this.iconOpacity, this.reactionCount,
      {super.key});
  final String emote;
  final String emoteTitle;
  final VoidCallback handleClick;
  final double iconOpacity;
  final int reactionCount;
  @override
  State<EmoteButton> createState() => _EmoteButtonState();
}

class _EmoteButtonState extends State<EmoteButton> {
  Color countBackground = MuhngaColors.secondary;
  Color textColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    if (widget.iconOpacity == 1.0) {
      countBackground = MuhngaColors.secondary;
      textColor = Colors.white;
    }
    return GestureDetector(
      child: Column(
        children: [
          Stack(children: [
            Opacity(
              opacity: widget.iconOpacity,
              child: Image.asset(widget.emote),
            ),
            if (widget.iconOpacity != 1.0)
              Positioned(
                  right: 00,
                  top: 5,
                  child: Container(
                      decoration: BoxDecoration(
                          color: countBackground,
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.reactionCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .apply(color: textColor),
                      )))
          ]),
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.emoteTitle,
                style: Theme.of(context).textTheme.titleMedium,
              )),
        ],
      ),
      onTap: () {
        countBackground = MuhngaColors.neon;
        textColor = MuhngaColors.primary;
        widget.handleClick();
      },
    );
  }
}
