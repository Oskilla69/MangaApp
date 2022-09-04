import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirebaseImage extends StatefulWidget {
  const FirebaseImage({Key? key, required this.uri}) : super(key: key);

  final String uri;
  @override
  State<FirebaseImage> createState() => _FirebaseImageState();
}

class _FirebaseImageState extends State<FirebaseImage> {
  final _storage = FirebaseStorage.instance;
  String downloadURL = "";
  Uint8List? imgData;

  _FirebaseImageState() {
    loadImage();
  }

  @override
  void initState() {
    super.initState();
  }

  void loadImage() {
    // _storage.refFromURL(widget.uri).getData(128 * 128).then((value) {
    //   setState(() {
    //     imgData = value;
    //   });
    // });
    print('widget uri $widget');
    _storage.refFromURL(widget.uri).getDownloadURL().then((value) {
      print('hi $value');
      setState(() {
        downloadURL = value;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // return imgData == null
    //     ? const CircularProgressIndicator()
    //     : Image.memory(imgData!);
    return downloadURL.isEmpty
        ? const CircularProgressIndicator()
        : CachedNetworkImage(
            imageUrl: downloadURL,
            placeholder: (context, val) {
              return const CircularProgressIndicator();
            });
  }

  Widget buildFutureImage() {
    return FutureBuilder(
      future: _storage.refFromURL(widget.uri).getDownloadURL(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          downloadURL = snapshot.data!;
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            alignment: FractionalOffset.topCenter,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text('Error');
        }
      },
    );
  }
}
