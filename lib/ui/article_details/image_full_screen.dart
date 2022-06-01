import 'dart:math';

import 'package:chedmed/ui/common/app_theme.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../common/buttons.dart';
import 'image_display.dart';

class ImageFullScreen extends StatelessWidget {
  const ImageFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var faker = Faker();

    return Container(
        child: PhotoView(
      imageProvider: NetworkImage(faker.image.image(keywords: ["clothes"])),
    ));
  }
}

class ImageFullScreenGalery extends StatefulWidget {
  const ImageFullScreenGalery({Key? key}) : super(key: key);

  @override
  State<ImageFullScreenGalery> createState() => _ImageFullScreenGaleryState();
}

class _ImageFullScreenGaleryState extends State<ImageFullScreenGalery> {
  List<ImageData> galleryItems = ["car", "watch", "clothes", "smartphone"]
      .map((e) => ImageData(url: faker.image.image(keywords: [e]), id: e))
      .toList();
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
    print(galleryItems.length);
    return Scaffold(
        body: Stack(
      children: [
        Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                controller: pageController,
                imageProvider: NetworkImage(galleryItems[index].url),
                initialScale: PhotoViewComputedScale.contained * 1,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: galleryItems[index].id),
              );
            },

            itemCount: galleryItems.length,

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
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Text(
            "Image $currentNumber /" + galleryItems.length.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
          ),
        ),
        SafeArea(
          child: Positioned(
              top: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        color: AppTheme.secondaryColor(context),
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
                        color: AppTheme.secondaryColor(context),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        SafeArea(
            child: Positioned(
          child: ReturnButton(),
          top: 5,
          left: 5,
        ))
      ],
    ));
  }
}
