import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tuple/tuple.dart';
import '../../../constants/constants.dart';
import '../../../models/camp/camp_prev.dart';
import '../../../models/search/markers_cluster.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/widgets/search_page_widget/auto_complete_tile.dart';
import '../../../ui/widgets/search_page_widget/custom_textField_search.dart';
import '../../../ui/widgets/search_page_widget/selected_camp_preview.dart';

class SearchResultAndMapView extends StatefulWidget {
  const SearchResultAndMapView({Key key, @required this.markerIcon})
      : super(key: key);
  final BitmapDescriptor markerIcon;
  @override
  _SearchResultAndMapViewState createState() => _SearchResultAndMapViewState();
}

class _SearchResultAndMapViewState extends State<SearchResultAndMapView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _places = MConstants.places;
  List<Marker> _markers;
  List<String> _suggest;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _markers = [];
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void _clearText() {
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    LatLng _target = _publicProv.mapTarget;
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: Selector<PublicProvider, List<MarkerCluster>>(
              selector: (context, publicProv) => publicProv.marker,
              shouldRebuild: (pre, next) => pre != next,
              builder: (context, _list, _) {
                if (_list.isNotEmpty) {
                  _target = _list[0].latLng;
                  _markers.addAll(_addToMarker(_list));
                }
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _target,
                    zoom: 8,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  zoomControlsEnabled: false,
                  markers: _markers.toSet(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: CustomTextFieldSearch(
                        controller: _textEditingController,
                        prefixicon: Icons.search_rounded,
                        fillColor: Theme.of(context).hoverColor,
                        iconSize: 26,
                        hint: 'search',
                        onchanged: (String value) {
                          if (value.length >= 2) {
                            _suggest = _places
                                .where(
                                  (place) => place.toLowerCase().contains(
                                        value.toLowerCase(),
                                      ),
                                )
                                .toList();
                          } else {
                            _suggest = [];
                          }
                          _publicProv.autoCompleteSet = _suggest;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                AutoCompleteTile(
                  searchInMap: true,
                  clearText: _clearText,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
                child: Selector<PublicProvider, List<CampSitePrev>>(
                  selector: (context, publicProv) => publicProv.searchedResult,
                  builder: (context, _list, _) {
                    if (_list.isEmpty) return SizedBox();
                    return ScrollablePositionedList.builder(
                      itemScrollController: _itemScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _list.length,
                      itemBuilder: (context, index) {
                        return CampListPreview(
                          campSitePrev: _list[index],
                        );
                      },
                    );
                  },
                ),
              ),
              Selector<PublicProvider, Tuple2<bool, bool>>(
                selector: (context, publicProv) =>
                    Tuple2(publicProv.hasNext, publicProv.fnTriggered),
                builder: (context, data, _) {
                  return data.item2
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SpinKitThreeBounce(
                            color: Theme.of(context).cardColor,
                            size: 30,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: data.item1 ? _getMore : () {},
                          child: Text(data.item1 ? 'get more' : 'no more'),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                right: 16,
                                left: 16,
                              ),
                            ),
                          ),
                        );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Marker> _addToMarker(List<MarkerCluster> list) {
    List<Marker> _marker = [];
    list.forEach((mark) {
      final _singleMarker = Marker(
        icon: widget.markerIcon,
        markerId: MarkerId(mark.markerId),
        position: mark.latLng,
        onTap: () {
          final i = Provider.of<PublicProvider>(context, listen: false)
              .getIndexOfMarker(mark.markerId);
          _itemScrollController.scrollTo(
            index: i,
            duration: Duration(milliseconds: 400),
          );
        },
      );
      _marker.add(_singleMarker);
    });
    return _marker;
  }

  Future<void> _getMore() async {
    await Provider.of<PublicProvider>(context, listen: false)
        .fetchCampPrevBySearch(false);
  }
}
