import 'package:flutter/material.dart';

class MuhngaAppBar extends StatelessWidget with PreferredSizeWidget {
  const MuhngaAppBar(
    this.title,
    this.leadingWidget,
    this.endingWidgets, {
    Key? key,
    this.appBarColor = Colors.transparent,
  }) : super(key: key);
  final String title;
  final Widget? leadingWidget;
  final List<Widget>? endingWidgets;
  final Color appBarColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
      child: Padding(
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
