import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:chedmed/ui/article_details/image_full_screen.dart';
import 'package:chedmed/ui/common/app_theme.dart';

import '../common/buttons.dart';
import '../common/no_cache.dart';
import '../home/annonce_presentation.dart';

class ImageDisplay extends StatefulWidget {
  List<String> images;
  ImageDisplay({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  List<String> images = [];
  String selected = "";

  @override
  void initState() {
    images = widget.images;

    selected = images.first;
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
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageFullScreenGalery(
                                images: images,
                              )));
                },
                child: Container(
                    height: 250,
                    width: double.infinity,
                    child: DynamicImagePreview(
                      fullSizePath:
                          images.where((element) => element == selected).first,
                      smallSizePath: AnnoncePresentation.getMiniImage(
                          images.where((element) => element == selected).first),
                    )),
              ),
              Positioned(
                child: ZoomButton(
                  images: widget.images,
                ),
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
                          imageUrl: AnnoncePresentation.getMiniImage(e),
                          selected: e == selected,
                          imageTapped: () {
                            selectImage(e);
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

class ZoomButton extends StatelessWidget {
  List<String> images;
  ZoomButton({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: MyElevatedButtonSmall(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageFullScreenGalery(
                        images: images,
                      )))
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.zoom_out_map_rounded,
              color: Colors.white,
            ),
            // Text(
            //   "Agrandir",
            //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            // )
          ],
        ),
      ),
    );
  }
}

class DynamicImagePreview extends StatelessWidget {
  String fullSizePath;
  String smallSizePath;
  DynamicImagePreview({
    Key? key,
    required this.fullSizePath,
    required this.smallSizePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loaded = false;
    return Container(
      child: Image.network(
        fullSizePath,
        fit: BoxFit.cover,
        loadingBuilder: (a, b, event) {
          final expectedBytes = event?.expectedTotalBytes;
          final loadedBytes = event?.cumulativeBytesLoaded;
          final value = loadedBytes != null && expectedBytes != null
              ? loadedBytes / expectedBytes
              : null;

          if (value == null) return b;
          return Stack(
            children: [
              Container(
                width: double.infinity,
                child: Image.network(
                  smallSizePath,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white.withOpacity(0.3),
                      value: value,
                    ),
                  ),
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}
