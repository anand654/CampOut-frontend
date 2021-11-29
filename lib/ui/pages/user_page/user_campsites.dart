import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../../constants/constants.dart';
import '../../../models/camp/camp_prev.dart';
import '../../../state_management/campSite/privateProvider.dart';
import '../../../ui/pages/user_page/add_campsite.dart';
import '../../../ui/widgets/global_widgets/alert_windows.dart';
import '../../../ui/widgets/global_widgets/loading_msg.dart';
import '../../../ui/widgets/global_widgets/loading_window.dart';
import '../../../ui/widgets/global_widgets/rating_bar.dart';
import 'package:provider/provider.dart';

class UserCampSite extends StatefulWidget {
  const UserCampSite({Key key}) : super(key: key);

  @override
  State<UserCampSite> createState() => _MyCampSiteState();
}

class _MyCampSiteState extends State<UserCampSite> {
  Future getCampPrev;
  @override
  void initState() {
    super.initState();
    getCampPrev = _getCampPrev();
  }

  Future _getCampPrev() async {
    await Provider.of<PrivateProvider>(context, listen: false)
        .getUserCampPrev();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left,
                size: 32, color: Theme.of(context).primaryColor),
          ),
          title: Text(
            'My Campsites',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: FutureBuilder<Object>(
            future: getCampPrev,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                  alignment: Alignment.center,
                  child: LoadingMessage(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Selector<PrivateProvider, List<CampSitePrev>>(
                    selector: (context, privateProv) => privateProv.userCamps,
                    shouldRebuild: (pre, next) => pre != next,
                    builder: (context, _list, _) {
                      if (_list.isEmpty) {
                        return Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No CampSites Added',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              LoadingMessage(),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return MyCampSiteCard(campSitePrev: _list[index]);
                        },
                        itemCount: _list.length,
                      );
                    },
                  ),
                );
              }
              return Align(
                alignment: Alignment.center,
                child: LoadingMessage(),
              );
            }),
      ),
    );
  }
}

class MyCampSiteCard extends StatelessWidget {
  const MyCampSiteCard({
    Key key,
    @required this.campSitePrev,
  }) : super(key: key);
  final CampSitePrev campSitePrev;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: AspectRatio(
        aspectRatio: 1.45,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BlurHash(
                      hash: MConstants.blurHash,
                      imageFit: BoxFit.cover,
                      curve: Curves.easeInOut,
                      image: campSitePrev.imageUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 16,
                    top: 6,
                    bottom: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          campSitePrev.campName,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.white,
                              ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                      MyRatingBar(
                        rating: campSitePrev.rating,
                        color: Colors.white,
                        iconSize: 16,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          campSitePrev.campAddress.address,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: Colors.white,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        '₹ ${campSitePrev.price} / day',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Colors.white,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _iconbutton(
                    Theme.of(context).primaryColor,
                    Icons.edit,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditCampSite(
                          campSitePrev: campSitePrev,
                          newCamp: false,
                        ),
                      ),
                    ),
                  ),
                  _iconbutton(
                    Theme.of(context).primaryColor,
                    Icons.delete,
                    () => _deleteCampsite(context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteCampsite(BuildContext context) async {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    final _dialogue = LoadingWindow(context: context);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertWindow(
          content: 'Delete Campsite Permanently ?',
          deletePressed: () async {
            _dialogue.loadingWindow('Deleting CampSite');
            final removed =
                await _privateProv.removeCampSite(campSitePrev.campPrevId);
            if (removed) {
              Navigator.pop(context);
              _dialogue.showSnackBar('Campsite deleted successfully', true);
            } else {
              Navigator.pop(context);
              _dialogue.showSnackBar('couldn\'t delete campsite', false);
            }
            Navigator.pop(context);
          },
          cancelPressed: () => Navigator.pop(context),
        );
      },
    );
  }

  Widget _iconbutton(Color color, IconData icon, VoidCallback onpressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      height: 40,
      child: IconButton(
        onPressed: onpressed,
        icon: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
