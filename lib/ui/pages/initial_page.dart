import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:me_and_my_tent_client/ui/pages/fav_page.dart';
import 'package:me_and_my_tent_client/ui/pages/home_page.dart';
import 'package:me_and_my_tent_client/ui/pages/search_page/search_page.dart';
import 'package:me_and_my_tent_client/ui/pages/user_page/user_page.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentTab = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Widget> pages = <Widget>[
    HomePage(
      key: PageStorageKey<String>('introPage'),
    ),
    SearchPage(
      key: PageStorageKey<String>('searchPage'),
    ),
    FavPage(
      key: PageStorageKey<String>('favPage'),
    ),
    UserPage(
      key: PageStorageKey<String>('userPage'),
    ),
  ];

  ontabTapped(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: PageStorage(
          bucket: _bucket,
          child: pages[_currentTab],
          // ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            _bottomNavBarItem(
              'assets/icons/home_icon.svg',
              Icons.home,
            ),
            _bottomNavBarItem(
              'assets/icons/search_icon.svg',
              Icons.search,
            ),
            _bottomNavBarItem(
              'assets/icons/fav_icon.svg',
              Icons.bookmark,
            ),
            _bottomNavBarItem(
              'assets/icons/user_icon.svg',
              Icons.person,
            ),
          ],
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          currentIndex: _currentTab,
          onTap: (int index) => ontabTapped(index),
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(
    String icon,
    IconData selectIcon,
  ) {
    return BottomNavigationBarItem(
      label: '',
      icon: SvgPicture.asset(
        icon,
        height: 22,
        color: Color(0xFF9DB6CB),
      ),
      activeIcon: SvgPicture.asset(
        icon,
        height: 22,
        color: Color(0xFF1D3557),
      ),
    );
  }
}
