import 'package:flutter/material.dart';
import 'package:mangaapp/shared/muhnga_icon_button.dart';

class MuhngaAppBar extends StatelessWidget with PreferredSizeWidget {
  const MuhngaAppBar(
    this.title,
    this.leadingWidget,
    this.endingWidgets, {
    Key? key,
  }) : super(key: key);
  final String title;
  final Widget? leadingWidget;
  final List<Widget>? endingWidgets;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 18.0, vertical: (kToolbarHeight - 42) / 2),
      child: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: leadingWidget,
        actions: endingWidgets,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
