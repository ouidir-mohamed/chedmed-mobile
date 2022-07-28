import 'dart:io';

import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/models/notifications_request.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/utils/time_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

import '../models/notification_check_response.dart';
import '../ressources/dao/sahel_dao.dart';
import '../ressources/shared_preference/shared_preference.dart';
import '../utils/notification_helper.dart';

class NotificationsBloc {
  checkRecommendationsFromIsolate() async {
    await initDatabaseInstance();
    await initNotifications();
    initSahelApi();
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    if (Platform.isIOS) SharedPreferencesIOS.registerWith();
    await SharedPreferenceData.init();
    print("task nnn 3");
    var serachHistory = await sahelDao.getAllHistory();

    print(serachHistory.first.lastVisitedDate);
    if (serachHistory.isEmpty) return;

    NotificationsRequest notificationsRequest = NotificationsRequest(
        username: SharedPreferenceData.loadUserName(),
        page: 1,
        items: serachHistory.map((e) {
          return RequestItem(
              category: e.categoryId,
              underCategory: e.underCategoryId,
              searchDate: e.searchDate,
              lastVisitedDate: e.lastVisitedDate,
              point:
                  Point(id: e.location_id, lat: e.latitude, long: e.longitude));
        }).toList());

    print(notificationsRequest);

    String? token = SharedPreferenceData.loadToken();
    print(token! + " wlh hada");
    if (token == null) return;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (request, handler) {
      request.headers["Authorization"] = "Bearer " + token;
      return handler.next(request);
    }));
    NotificationCheckResponse res =
        await chedMedApi.checkNotifications(notificationsRequest);

    print(res.available.toString() + " wellllllllah");
    if (res.available) displayNotification(res.title, res.message);
    int lastValidId = serachHistory.last.id!;
    await sahelDao.deleteOldHistoryItems(lastValidId);
  }

  PublishSubject<List<Annonce>> _annoncesFetcher = PublishSubject();
  PublishSubject<bool> _loadingFetcher = PublishSubject();

  Stream<List<Annonce>> get getAnnonces => _annoncesFetcher.stream;
  Stream<bool> get getLoading => _loadingFetcher.stream;

  getRocommendations() async {
    var searchHistory = await sahelDao.getAllHistory();
    print(searchHistory);
    NotificationsRequest notificationsRequest = NotificationsRequest(
        username: SharedPreferenceData.loadUserName(),
        page: 1,
        items: searchHistory.map((e) {
          return RequestItem(
              category: e.categoryId,
              underCategory: e.underCategoryId,
              searchDate: e.searchDate,
              lastVisitedDate: e.lastVisitedDate,
              point:
                  Point(id: e.location_id, lat: e.latitude, long: e.longitude));
        }).toList());

    _loadingFetcher.sink.add(false);

    chedMedApi.getNotificationPosts(notificationsRequest).then((value) {
      _annoncesFetcher.sink.add(value);
      _loadingFetcher.sink.add(false);
      sahelDao.updateLastVisitedDate(
          DateTime.now().subtract(Duration(days: 2)).toDateTimeString());
    });
  }
}
