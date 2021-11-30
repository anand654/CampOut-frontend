import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:me_and_my_tent_client/models/camp/camp_prev.dart';
import 'package:me_and_my_tent_client/models/camp/camp_reviews.dart';
import 'package:me_and_my_tent_client/models/camp/camp_site.dart';
import 'package:me_and_my_tent_client/models/search/markers_cluster.dart';
import 'package:me_and_my_tent_client/models/stories.dart';
import 'package:me_and_my_tent_client/services/helpers/ihelpers.dart';
import 'package:me_and_my_tent_client/services/webview/webpreview.dart';

class Helpers implements IHelpers {
  @override
  Uri urlParser(String path) {
    return Uri.parse('base-url');
  }

  @override
  List<String> searchArea(double lat, double long, double rad) {
    double latTol = (0.009009 * rad);
    double longTol = (0.112359 * rad);
    List<String> area = [];
    area.add((lat - latTol).toStringAsFixed(6));
    area.add((lat + latTol).toStringAsFixed(6));
    area.add((long - longTol).toStringAsFixed(6));
    area.add((long + longTol).toStringAsFixed(6));
    return area;
  }

  @override
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return Future.error('error $e');
    }
  }

  @override
  List<Stories> jsontoStories(Map<String, dynamic> jsondata) {
    final List<dynamic> data = jsondata['stories'];
    if (data.isEmpty) return [];
    return data
        .map((story) => Stories.fromJson(story as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PreviewInfo>> urlPreview(Map<String, dynamic> jsondata) async {
    final List<dynamic> data = jsondata['stories'];
    List<PreviewInfo> _webPage = [];
    try {
      await Future.forEach(data, (story) async {
        final _prev = await WebPageInfo().previewInfo(story['url'] as String);
        _webPage.add(_prev);
      });
    } catch (error) {}
    return _webPage;
  }

  @override
  List<CampSitePrev> jsontoCampPrev(Map<String, dynamic> jsondata) {
    final List<dynamic> data = jsondata['campprev'];
    if (data.isEmpty) return [];
    return data
        .map((prev) => CampSitePrev.fromJson(prev as Map<String, dynamic>))
        .toList();
  }

  @override
  CampSite jsontoCampsite(Map<String, dynamic> jsondata) {
    return CampSite.fromJson(jsondata['campsite'] as Map<String, dynamic>);
  }

  @override
  List<CampReviews> jsontoCampReviews(Map<String, dynamic> jsondata) {
    final List<dynamic> _data = jsondata['reviews'];
    if (_data.isEmpty) return [];
    return _data
        .map((review) => CampReviews.fromJson(review as Map<String, dynamic>))
        .toList();
  }

  @override
  List<CampSitePrev> jsontoSavedCampSite(Map<String, dynamic> jsondata) {
    final List<dynamic> data = jsondata['userFavs'];
    if (data.isEmpty) return [];
    return data
        .map((saved) => CampSitePrev.fromJson(saved as Map<String, dynamic>))
        .toList();
  }

  @override
  String favCampSiteToJson(String favCamp) {
    return jsonEncode({'campPrevId': favCamp});
  }

  @override
  String camptojson(CampSitePrev campprev, CampSite campsite) {
    return jsonEncode(
        {'campsite': campsite.toJson(), 'campprev': campprev.toJson()});
  }

  @override
  List<MarkerCluster> jsontoMarkerCluster(Map<String, dynamic> jsondata) {
    final List<dynamic> data = jsondata['campprev'];
    if (data.isEmpty) return [];
    return data
        .map(
          (review) => MarkerCluster.fromJson(
            review['_id'] as String,
            review['campAddress']['lat'] as double,
            review['campAddress']['long'] as double,
          ),
        )
        .toList();
  }

  @override
  String placeMarkToAddress(Placemark place) {
    return '${place.subThoroughfare ?? ''},${place.thoroughfare ?? ''},${place.subLocality ?? ''},${place.locality ?? ''},${place.administrativeArea ?? ''}';
  }

  @override
  String listofStrToJson(List<String> list) {
    List<String> _list = list.map((url) => url.split('/').last).toList();
    return jsonEncode({'willRemoveImgUrls': _list});
  }

  @override
  List<String> jsonToListofStr(Map<String, dynamic> jsondata) {
    return jsondata['willRemoveImgUrls'].cast<String>();
  }
}
