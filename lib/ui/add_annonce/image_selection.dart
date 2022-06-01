import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../common/app_theme.dart';

class ImageSelection extends StatefulWidget {
  const ImageSelection({Key? key}) : super(key: key);

  @override
  State<ImageSelection> createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  List<String> pickedImages = [];
  List<String> selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  openCamera() async {
    final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 600, maxWidth: 600);
    if (photo != null)
      setState(() {
        pickedImages.add(photo.path);
      });
  }

  openGallery() async {
    final List<XFile>? images =
        await _picker.pickMultiImage(maxHeight: 600, maxWidth: 600);
    if (images != null)
      setState(() {
        pickedImages.addAll(images.map((e) => e.path));
      });
  }

  selectImage(String image) {
    setState(() {
      selectedImages.contains(image)
          ? selectedImages.remove(image)
          : selectedImages.add(image);
    });
  }

  deleteImages() {
    setState(() {
      pickedImages.removeWhere((element) => selectedImages.contains(element));
      selectedImages.removeWhere((element) => selectedImages.contains(element));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text("Ajouter des photos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: pickedImages
                    .map((e) => ImagePreview(
                          imageUrl: e,
                          selected: selectedImages.contains(e),
                          imageTapped: () {
                            selectImage(e);
                          },
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AddPictureButton(
                      onTap: () {
                        openCamera();
                      },
                      title: "Caméra",
                      icon: MaterialCommunityIcons.camera_plus),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AddPictureButton(
                        onTap: () {
                          openGallery();
                        },
                        title: "Gallerie",
                        icon: FontAwesome.picture_o),
                  ),
                  selectedImages.isNotEmpty
                      ? AddPictureButton(
                          onTap: () {
                            deleteImages();
                          },
                          title: "Supprimer",
                          icon: FontAwesome.trash)
                      : Container(),
                ],
              ),
            ),
          ],
        ));
  }
}

class AddPictureButton extends StatelessWidget {
  String title;
  IconData icon;
  void Function()? onTap;

  AddPictureButton(
      {Key? key, required this.title, required this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        color: AppTheme.cardColor(context),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 80,
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: AppTheme.secondaryColor(context),
                      size: 26,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  String imageUrl;
  bool selected;
  void Function()? imageTapped;
  ImagePreview({
    Key? key,
    required this.imageUrl,
    required this.selected,
    this.imageTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: imageTapped,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.file(
                  File(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: selected
                    ? BoxDecoration(
                        color: AppTheme.primaryColor(context)
                            .withOpacity(selected ? 0.3 : 0.3),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: AppTheme.primaryColor(context), width: 2))
                    : BoxDecoration(),
              )
            ],
          ),
        ),
      ),
    );
  }
}