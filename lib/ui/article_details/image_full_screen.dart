import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:chedmed/ui/common/app_theme.dart';

import '../common/buttons.dart';
import 'image_display.dart';

class ImageFullScreen extends StatelessWidget {
  String image;
  ImageFullScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: NetworkImage(image),
    ));
  }
}

class ImageFullScreenGalery extends StatefulWidget {
  List<String> images;
  ImageFullScreenGalery({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<ImageFullScreenGalery> createState() => _ImageFullScreenGaleryState();
}

class _ImageFullScreenGaleryState extends State<ImageFullScreenGalery> {
  int currentNumber = 1;

  PhotoViewController pageController = new PhotoViewController();

  imageChanged(int index) {
    pageController.rotation = 0;

    setState(() {
      currentNumber = index + 1;
    });
  }

  rotateRight() {
    pageController.rotation += pi / 2;
  }

  rotateLedt() {
    pageController.rotation -= pi / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              controller: pageController,
              imageProvider: NetworkImage(widget.images[index]),
              initialScale: PhotoViewComputedScale.contained * 1,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: widget.images[index]),
            );
          },

          itemCount: widget.images.length,

          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          // backgroundDecoration: widget.backgroundDecoration,

          onPageChanged: imageChanged,
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Text(
            "Image $currentNumber /" + widget.images.length.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SafeArea(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        rotateLedt();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 10),
                        child: Icon(
                          FontAwesome.rotate_left,
                          size: 28,
                          color: AppTheme.primaryColor(context),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        rotateRight();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 10),
                        child: Icon(
                          FontAwesome.rotate_right,
                          size: 28,
                          color: AppTheme.primaryColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Positioned(
          child: SafeArea(child: ReturnButton()),
          top: 5,
          left: 5,
        )
      ],
    ));
  }
}
