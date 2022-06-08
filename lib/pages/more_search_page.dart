import 'package:flutter/material.dart';

class SearchOverlay extends ModalRoute<void> {
  @override
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Close Additional Search Options';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    throw UnimplementedError();
  }

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => throw UnimplementedError();
}
