import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:me_and_my_tent_client/models/camp/camp_prev.dart';
import 'package:me_and_my_tent_client/models/camp/camp_reviews.dart';
import 'package:me_and_my_tent_client/models/camp/camp_site.dart';
import 'package:me_and_my_tent_client/models/search/markers_cluster.dart';
import 'package:me_and_my_tent_client/models/stories.dart';
import 'package:me_and_my_tent_client/services/webview/webpreview.dart';

abstract class IHelpers {
  Uri urlParser(String path);
  List<String> searchArea(double lat, double long, double rad);
  Future<Position> determinePosition();
  String placeMarkToAddress(Placemark place);

  List<Stories> jsontoStories(Map<String, dynamic> jsondata);
  Future<List<PreviewInfo>> urlPreview(Map<String, dynamic> jsondata);

  List<CampSitePrev> jsontoCampPrev(Map<String, dynamic> jsondata);
  CampSite jsontoCampsite(Map<String, dynamic> jsondata);
  String camptojson(CampSitePrev campprev, CampSite campsite);

  List<CampReviews> jsontoCampReviews(Map<String, dynamic> jsondata);

  List<CampSitePrev> jsontoSavedCampSite(Map<String, dynamic> jsondata);
  String favCampSiteToJson(String favCamp);

  List<MarkerCluster> jsontoMarkerCluster(Map<String, dynamic> jsondata);

  String listofStrToJson(List<String> list);
  List<String> jsonToListofStr(Map<String, dynamic> jsondata);
}
