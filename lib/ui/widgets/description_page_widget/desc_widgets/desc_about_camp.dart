import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/constants.dart';
import '../../../../models/camp/camp_prev.dart';
import '../../../../state_management/auth/authProvider.dart';
import '../../../../state_management/campSite/privateProvider.dart';
import '../../../../state_management/campSite/publicProvider.dart';
import '../../global_widgets/alert_windows.dart';

class DescAboutCamp extends StatelessWidget {
  const DescAboutCamp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);

    final CampSitePrev _campSitePrev = _publicProv.currentCampSitePrev;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Theme.of(context).cardColor,
              ),
              borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Campground',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _aboutText(
                              context, _publicProv.currentCampSite.about),
                          _aboutText(context, _campSitePrev.campName),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _aboutText(context, _campSitePrev.campAddress.address, 2),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Container(
                  child: Row(
                    children: [
                      Selector<PublicProvider, bool>(
                        selector: (context, publicProv) =>
                            publicProv.isFavorite,
                        shouldRebuild: (pre, next) => pre != next,
                        builder: (context, isFavorite, _) {
                          return Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('save'),
                    ],
                  ),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => _saveCamp(context, _publicProv, _campSitePrev),
              ),
              const SizedBox(
                height: 30,
              ),
              shareButton(
                Icons.location_on,
                'direction',
                () async => await _openMap(
                  _campSitePrev.campAddress.lat.toString(),
                  _campSitePrev.campAddress.long.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aboutText(BuildContext context, String data, [int maxlines]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        data,
        style: Theme.of(context).textTheme.subtitle2,
        overflow: TextOverflow.ellipsis,
        maxLines: maxlines ?? 1,
      ),
    );
  }

  Widget shareButton(IconData icon, String title, VoidCallback ontap) {
    return InkWell(
      child: Container(
        child: Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(title),
          ],
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: ontap,
    );
  }

  Future<void> _saveCamp(BuildContext context, PublicProvider publicProv,
      CampSitePrev campSitePrev) async {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    final _authProv = Provider.of<AuthProvider>(context, listen: false);
    if (_authProv.authState == AuthState.signedOut) {
      await showDialog(
        context: context,
        builder: (context) => AlertWindow(
          content: 'Your are not logged in, Please login to proceed further',
          isLogin: true,
          deletePressed: () {},
          cancelPressed: () => Navigator.pop(context),
        ),
      );
    } else {
      publicProv.toggleFavorite(campSitePrev.campId);
      publicProv.isFavorite
          ? await _privateProv.addUserFavs(
              campSitePrev,
            )
          : await _privateProv.deleteUserFavs(campSitePrev.campPrevId);
    }
  }

  Future<void> _openMap(String lat, String long) async {
    String _googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(_googleUrl)) {
      await launch(_googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
