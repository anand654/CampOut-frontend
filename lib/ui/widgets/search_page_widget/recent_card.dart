import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/search/recent_search.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/pages/search_page/search_result_page.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({
    Key key,
    @required this.recentSearch,
    this.clearText,
  }) : super(key: key);
  final RecentSearch recentSearch;
  final void Function() clearText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          recentSearch.place,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(
          recentSearch.city,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        dense: true,
        contentPadding: const EdgeInsets.only(bottom: 5),
        onTap: () => _searchUsingRecent(context),
      ),
    );
  }

  Future<void> _searchUsingRecent(BuildContext context) async {
    FocusScope.of(context).unfocus();
    clearText();
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    _publicProv.searchKeywordSet = recentSearch.place;
    _publicProv.autoCompleteSet = [];
    _publicProv.campTypeSet = 'camptype';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResultPage(),
      ),
    );
  }
}
