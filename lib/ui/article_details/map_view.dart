import 'dart:async';

import 'package:chedmed/ui/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MapView extends StatefulWidget {
  LatLng center;
  MapView({
    Key? key,
    required this.center,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 280,
        child: FlutterMap(
            options: MapOptions(
              minZoom: 4,
              center: widget.center,
              zoom: 12,
              crs: mapLayer.epsg,
              onTap: (pos, lat) => {},
            ),
            children: [
              TileLayerWidget(
                  options: TileLayerOptions(
                backgroundColor: AppTheme.cardColor(context),
                urlTemplate: mapLayer.getUrl(context),
                subdomains: ['a', 'b', 'c'],
                maxNativeZoom: 18.5,
                additionalOptions: {"key": "G4MdCtrNeG6VkmGJG6Eg"},
                minZoom: 4,
              )),
              MarkerLayerWidget(
                  options: MarkerLayerOptions(markers: [
                Marker(
                    width: 18,
                    height: 18,
                    point: widget.center,
                    builder: (context) => SvgPicture.asset(
                          "./assets/center_location.svg",
                          width: 18,
                          height: 18,
                        ))
              ]))
            ]));
  }
}

final mapLayer = MapLayer(
    url: "https://api.maptiler.com/maps/streets/{z}/{x}/{y}@2x.png?key={key}",
    darkUrl:
        "https://api.maptiler.com/maps/jp-mierune-dark/{z}/{x}/{y}@2x.png?key={key}",
    epsg: Epsg3857());

class MapLayer {
  final String url;
  final String darkUrl;
  final Earth epsg;
  MapLayer({
    required this.url,
    required this.darkUrl,
    required this.epsg,
  });

  String getUrl(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) return url;
    return darkUrl;
  }
}

showMapBottomSheet(BuildContext context, LatLng center, String name) {
  showBarModalBottomSheet(
      context: context,
      topControl: Container(),
      bounce: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(15)),
      ),
      expand: false,
      builder: (context) => Container(
            height: 335,
            color: AppTheme.cardColor(context),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Ionicons.location_sharp,
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        Text(
                          name,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
                MapView(center: center),
              ],
            ),
          ));
}
