import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerCluster {
  final String markerId;
  final LatLng latLng;
  MarkerCluster({this.markerId, this.latLng});

  factory MarkerCluster.fromJson(String markerid, double lat, double long) {
    return MarkerCluster(
      markerId: markerid,
      latLng: LatLng(lat, long),
    );
  }
}
