import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SafeArea(
        child: Column(
          children: [
            Ink.image(
              image: const AssetImage('assets/images/dino.png'),
              height: 200,
              width: 200,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  print('subscribed!!!');
                },
                splashColor: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(FontAwesomeIcons.rightToBracket),
                    Text('Subscribe')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
