import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants/constants.dart';
import '../../../state_management/auth/authProvider.dart';
import '../../../ui/pages/user_page/add_campsite.dart';
import '../../../ui/pages/user_page/user_campsites.dart';
import '../../../ui/pages/user_page/user_reviews.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authProv = Provider.of<AuthProvider>(context, listen: false);
    final _userInfo = _authProv.user;
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(fontSize: 16),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.settings),
                  iconSize: 28,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        child: Text(
                          'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.white),
                        ),
                        height: 30,
                        onTap: () => _authProv.signOut(),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 60, right: 40),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: BlurHash(
                      hash: MConstants.blurHash,
                      imageFit: BoxFit.cover,
                      curve: Curves.easeInOut,
                      image: _userInfo.profileImg,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _userInfo.name,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        _userInfo.email,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Card(
                            shape: StadiumBorder(),
                            color: Theme.of(context).cardColor,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 8, bottom: 8),
                              child: Icon(
                                FontAwesomeIcons.signOutAlt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            _authProv.signOut();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 70),
              child: ListView(
                children: [
                  _listTile(
                    context,
                    'assets/icons/add_campsite.svg',
                    'Add campsite',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditCampSite(),
                        ),
                      );
                    },
                  ),
                  _listTile(
                    context,
                    'assets/icons/my_campsite.svg',
                    'My campsite',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserCampSite()));
                    },
                  ),
                  _listTile(
                    context,
                    'assets/icons/my_reviews.svg',
                    'My reviews',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserReviews(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/svg/user_bg_tree.svg',
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  ListTile _listTile(
      BuildContext context, String icon, String title, VoidCallback ontap) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        height: 18,
      ),
      title: Text(title),
      onTap: ontap,
    );
  }
}
