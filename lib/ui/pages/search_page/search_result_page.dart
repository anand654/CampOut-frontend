import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/widgets/global_widgets/loading_msg.dart';
import '../../../ui/widgets/search_page_widget/search_result_and_mapview.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key key}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  Future searchCampPrev;
  BitmapDescriptor _customIcon;
  @override
  void initState() {
    super.initState();
    searchCampPrev = _searchCamps();
  }

  Future _searchCamps() async {
    await Provider.of<PublicProvider>(context, listen: false)
        .fetchCampPrevBySearch(true);
    ByteData data = await rootBundle.load("assets/images/marker.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 100);
    ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List markerIcon =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))
            .buffer
            .asUint8List();
    _customIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
            future: searchCampPrev,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                return Center(
                  child: LoadingMessage(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return SearchResultAndMapView(
                  markerIcon: _customIcon,
                );
              }
              return Center(
                child: LoadingMessage(),
              );
            }),
      ),
    );
  }
}
