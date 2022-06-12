import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:kdtree/kdtree.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart';

import '../models/city.dart';
import 'location_helper.dart';

class LocationsBloc {
  final _allCitiesFetcher = BehaviorSubject<List<City>>();
  final _foundCityFetcher = PublishSubject<City>();

  Stream<List<City>> get getAllCities => _allCitiesFetcher.stream.startWith([]);
  Stream<City> get getFoundCity => _foundCityFetcher.stream;
  loadCties() async {
    final String response = await rootBundle.loadString('assets/cities.json');
    final List data = await json.decode(response);
    var cities = data.map<City>((element) {
      return City.fromJson(element!);
    }).toList();
    _allCitiesFetcher.sink.add(cities);

    initKDTree();
  }

  City getCityById(int cityId) {
    return _allCitiesFetcher.value
        .firstWhere((element) => element.id == cityId);
  }

  // !!!!! Kd tree to ve moved
  late KDTree tree;

  initKDTree() async {
    List<Map<dynamic, dynamic>> treePoints = [];

    distance(a, b) {
      return pow(a['x'] - b['x'], 2) + pow(a['y'] - b['y'], 2);
    }

    tree = KDTree(treePoints, distance, ['x', 'y']);

    _allCitiesFetcher.value
        .forEach((e) => tree.insert({"x": e.long, "y": e.lat, "id": e.id}));
  }

  City _detectCurrentLocation(LatLng point) {
    var nearest = tree.nearest({'x': point.longitude, 'y': point.latitude}, 1);
    return _allCitiesFetcher.value
        .firstWhere((city) => city.id == nearest[0][0]["id"]);
  }

  requestCurrentLocation() async {
    var value = await locationHelper.getData();
    City city =
        _detectCurrentLocation(LatLng(value.latitude!, value.longitude!));
    _foundCityFetcher.sink.add(city);
  }
}

LocationsBloc locationsBloc = LocationsBloc();
