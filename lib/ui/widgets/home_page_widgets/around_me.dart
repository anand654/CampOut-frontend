import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/pages/search_page/search_result_page.dart';

class AroundMeIcons extends StatelessWidget {
  const AroundMeIcons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AroundMeIcon(
            svgIcon: 'assets/svg/tentcamp.svg',
            label: 'Tent Camping',
          ),
          AroundMeIcon(
            svgIcon: 'assets/svg/rv_van.svg',
            label: 'Rv and Van',
          ),
          AroundMeIcon(
            svgIcon: 'assets/svg/glamping.svg',
            label: 'Glamping',
          ),
          AroundMeIcon(
            svgIcon: 'assets/svg/backpacking.svg',
            label: 'Backpacking',
          ),
        ],
      ),
    );
  }
}

class AroundMeIcon extends StatelessWidget {
  const AroundMeIcon({
    Key key,
    @required this.svgIcon,
    @required this.label,
  }) : super(key: key);
  final String svgIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              child: SvgPicture.asset(
                svgIcon,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async => await _aroundMeSearch(context, label),
    );
  }

  Future<void> _aroundMeSearch(BuildContext context, String campType) async {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    final String _searchKeyword = await _publicProv.getLocality();
    if (_searchKeyword == 'error') {
      return;
    } else {
      _publicProv.searchKeywordSet = _searchKeyword;
      _publicProv.campTypeSet = campType;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResultPage(),
        ),
      );
    }
  }
}
