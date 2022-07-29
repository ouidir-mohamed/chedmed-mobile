import 'package:chedmed/ui/own_article_details/image_full_screen.dart';
import 'package:flutter/material.dart';

import '../common/buttons.dart';
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
    var fullDisplayedImagesLinks =
        images.length <= 4 ? images : images.sublist(0, 3);
    List<Widget> displayedImagesWidgets = fullDisplayedImagesLinks
        .map((e) => ImagePreview(
              imageUrl: AnnoncePresentation.getMiniImage(e),
              selected: e == selected,
              imageTapped: () {
                selectImage(e);
              },
            ) as Widget)
        .toList();

    if (images.length > 4) {
      displayedImagesWidgets.add(LatestImagePreview(
          imagesLeftNumber: images.length - 3,
          imageUrl: images[4],
          imageTapped: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageFullScreenGalery(
                          images: images,
                        )));
          }) as Widget);
    }

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
                  child: Image.network(
                    images.where((element) => element == selected).first,
                    fit: BoxFit.cover,
                  ),
                ),
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
                children: displayedImagesWidgets),
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

class LatestImagePreview extends StatelessWidget {
  String imageUrl;
  int imagesLeftNumber;
  void Function() imageTapped;
  LatestImagePreview({
    Key? key,
    required this.imageUrl,
    required this.imagesLeftNumber,
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
          child: Stack(
            children: [
              Container(
                height: 70,
                width: 70,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 70,
                width: 70,
                color: Colors.black.withOpacity(0.7),
                child: Center(
                    child: Text(
                  "+" + imagesLeftNumber.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )),
              )
            ],
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
