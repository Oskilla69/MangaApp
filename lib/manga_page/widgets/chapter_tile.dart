import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';

class ChapterTile extends StatelessWidget {
  const ChapterTile(this.chapter, {super.key});
  final int chapter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Chapter ${chapter.toString()}',
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('20 Aug, 2022',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MuhngaColors.grey)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.lock)
            ],
          ),
          const Divider(color: MuhngaColors.grey, thickness: 0.25, height: 36),
        ],
      ),
    );
  }
}
