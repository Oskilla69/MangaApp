import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MuhngaImage extends StatelessWidget {
  const MuhngaImage(
      {super.key, required this.highResURL, required this.lowResURL});
  final String highResURL;
  final String lowResURL;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: highResURL,
      placeholder: (context, url) => CachedNetworkImage(
        imageUrl: lowResURL,
        placeholder: (context, url) => const CircularProgressIndicator(),
      ),
    );
  }
}
