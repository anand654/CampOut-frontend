import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/pages/search_page/search_result_page.dart';

class AutoCompleteTile extends StatelessWidget {
  const AutoCompleteTile({Key key, this.searchInMap = false, this.clearText})
      : super(key: key);
  final bool searchInMap;
  final void Function() clearText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Selector<PublicProvider, List<String>>(
        selector: (context, publicProv) => publicProv.autoComplete,
        shouldRebuild: (pre, next) => pre != next,
        builder: (context, _list, _) {
          return Container(
            margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
            height: _list.length >= 5 ? 200.0 : (_list.length * 55.0),
            decoration: BoxDecoration(
              color: searchInMap
                  ? Theme.of(context).hoverColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 55,
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      _list[index],
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    subtitle: Text(
                      'Karnataka',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    dense: true,
                    contentPadding: const EdgeInsets.only(bottom: 5),
                    onTap: () => _searchPlace(context, _list[index]),
                  ),
                );
              },
              itemCount: _list.length,
            ),
          );
        },
      ),
    );
  }

  Future<void> _searchPlace(BuildContext context, String searchKey) async {
    FocusScope.of(context).unfocus();
    clearText();
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    _publicProv.searchKeywordSet = searchKey;
    _publicProv.recentSearchesSet = searchKey;
    _publicProv.autoCompleteSet = [];
    _publicProv.campTypeSet = 'camptype';
    await _publicProv.userPosition();
    if (searchInMap) {
      await _publicProv.fetchCampPrevBySearch(true);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResultPage(),
        ),
      );
    }
  }
}
