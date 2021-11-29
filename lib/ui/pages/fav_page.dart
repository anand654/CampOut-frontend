import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../models/camp/camp_prev.dart';
import '../../../state_management/auth/authProvider.dart';
import '../../../state_management/campSite/privateProvider.dart';
import '../../../ui/widgets/fav_page_widget/fav_page_widget.dart';
import '../../../ui/widgets/global_widgets/loading_msg.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key key}) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  void initState() {
    super.initState();
    fetchSavedCamp();
  }

  Future fetchSavedCamp() async {
    final _authState =
        Provider.of<AuthProvider>(context, listen: false).authState;
    if (_authState == AuthState.signedOut) {
      return;
    }
    await Provider.of<PrivateProvider>(context, listen: false).getUserFavs();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/svg/favBG.svg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Saved CampSites',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Selector<PrivateProvider, List<CampSitePrev>>(
                    selector: (context, privateProv) =>
                        privateProv.favCampSites,
                    shouldRebuild: (pre, next) => pre != next,
                    builder: (context, _list, _) {
                      if (_list == null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('add camps to favorites'),
                            LoadingMessage(),
                          ],
                        );
                      }
                      if (_list.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('add camps to favorites'),
                            LoadingMessage(),
                          ],
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 5,
                          right: 15,
                          left: 15,
                        ),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SavedCard(
                            savedCampSite: _list[index],
                          );
                        },
                        itemCount: _list.length,
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
