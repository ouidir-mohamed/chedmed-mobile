import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';

class NonCacheNetworkImage extends StatelessWidget {
  const NonCacheNetworkImage(this.imageUrl, {Key? key, this.fit})
      : super(key: key);
  final String imageUrl;
  final BoxFit? fit;
  Future<Uint8List> getImageBytes() async {
    Response response = await get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: getImageBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Image.memory(
            snapshot.data!,
            fit: fit,
          );
        return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).canvasColor;
    var brightness = Theme.of(context).brightness;
    Color baseColor;
    Color highlightColor;

    if (brightness == Brightness.light) {
      baseColor = Colors.white;
      highlightColor = Colors.grey[200]!;
    } else {
      baseColor = Color(0xFF1D1D1D);
      highlightColor = Color(0XFF3C4042);
    }

    return Container(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: Duration(milliseconds: 700),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: backgroundColor),
        ),
      ),
    );
  }
}
