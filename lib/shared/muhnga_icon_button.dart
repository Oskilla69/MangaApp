import 'package:flutter/material.dart';

class MuhngaIconButton extends StatelessWidget {
  const MuhngaIconButton(this.icon, this.onPressed, {Key? key})
      : super(key: key);
  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 21,
      backgroundColor: Colors.white,
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
