import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingAppBar({
    required this.child,
    required this.controller,
    required this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SizedBox(
      height: 80.h,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        child: child,
      ),
    );
  }
}
