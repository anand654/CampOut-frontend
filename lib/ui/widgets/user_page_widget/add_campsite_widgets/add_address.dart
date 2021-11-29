import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../models/camp/camp_address.dart';
import '../../../../state_management/campSite/privateProvider.dart';
import '../../../../ui/widgets/global_widgets/loading_msg.dart';

class AddressPicker extends StatefulWidget {
  const AddressPicker({Key key}) : super(key: key);
  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  Completer<GoogleMapController> _controller = Completer();
  Future<Position> _getCurrentLoc;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLoc = getLoc();
  }

  Future<Position> getLoc() async {
    return await Provider.of<PrivateProvider>(context, listen: false)
        .currentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Theme.of(context).cardColor,
        ),
        borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
            child: Text(
              'Add address',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            child: Selector<PrivateProvider, CampAddress>(
              selector: (context, privateProv) => privateProv.mapToAddress,
              shouldRebuild: (pre, next) => pre != next,
              builder: (context, maptoaddress, _) {
                if (maptoaddress.address == null) return SizedBox();
                return Text(
                  maptoaddress.address ?? '',
                  style: Theme.of(context).textTheme.subtitle1,
                  maxLines: 2,
                );
              },
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(MConstants.bigborderRadius),
                    bottomRight: Radius.circular(MConstants.bigborderRadius),
                  ),
                  child: FutureBuilder(
                    future: _getCurrentLoc,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active &&
                          snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingMessage();
                      }
                      if (snapshot.hasData) {
                        final Position _pos = snapshot.data;
                        final CameraPosition _location = CameraPosition(
                          target: LatLng(_pos.latitude, _pos.longitude),
                          zoom: 14.92,
                        );
                        return GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _location,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          zoomControlsEnabled: false,
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer())
                          },
                          onCameraMove: (CameraPosition position) async {
                            if (_timer != null) {
                              _timer.cancel();
                            }
                            _timer = new Timer(
                              Duration(milliseconds: 5000),
                              () => _privateProv.mapToAddressSet(
                                position.target.latitude,
                                position.target.longitude,
                              ),
                            );
                          },
                        );
                      }
                      if (snapshot.hasError) {}
                      return LoadingMessage();
                    },
                  ),
                ),
              ),
              Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
