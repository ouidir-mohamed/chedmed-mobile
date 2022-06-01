import 'package:cached_network_image/cached_network_image.dart';
import 'package:chedmed/ui/article_details/image_full_screen.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../common/buttons.dart';
import '../common/no_cache.dart';

class ImageDisplay extends StatefulWidget {
  ImageDisplay({Key? key}) : super(key: key);

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  var faker = Faker();
  List<ImageData> images = [];
  String selected = "car";

  @override
  void initState() {
    print("refetching....");
    images = ["car", "watch", "clothes", "smartphone"]
        .map((e) => ImageData(url: faker.image.image(keywords: [e]), id: e))
        .toList();
    selected = images.first.id;
    super.initState();
  }

  selectImage(String id) {
    setState(() {
      selected = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        //color: AppTheme.cardColor(context),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                child: Image.network(
                  images.where((element) => element.id == selected).first.url,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: ZoomButton(),
                bottom: 5,
                right: 5,
              ),
            ],
          ),
          //
          //   child: CachedNetworkImage(

          //     imageUrl:
          //         images.where((element) => element.id == selected).first.url,
          //     placeholder: (context, url) => new Loading(),
          //     fit: BoxFit.cover,
          //   ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: images
                    .map((e) => ImagePreview(
                          imageUrl: e.url,
                          selected: e.id == selected,
                          imageTapped: () {
                            selectImage(e.id);
                          },
                        ))
                    .toList()),
          ),
        ],
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  String imageUrl;
  bool selected;
  void Function() imageTapped;
  ImagePreview({
    Key? key,
    required this.imageUrl,
    required this.selected,
    required this.imageTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: imageTapped,
          child: Opacity(
            opacity: selected ? 1 : 0.3,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class ImageData {
  String url;
  String id;
  ImageData({
    required this.url,
    required this.id,
  });
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

class ZoomButton extends StatelessWidget {
  const ZoomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyElevatedButton(
      color: AppTheme.secondaryColor(context),
      onPressed: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ImageFullScreenGalery()))
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.zoom_out_map_rounded,
              color: Colors.white,
            ),
          ),
          Text(
            "Agrandir",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }
}
