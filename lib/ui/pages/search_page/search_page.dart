import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../../models/search/recent_search.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/widgets/home_page_widgets/around_me.dart';
import '../../../ui/widgets/search_page_widget/auto_complete_tile.dart';
import '../../../ui/widgets/search_page_widget/custom_textField_search.dart';
import '../../../ui/widgets/search_page_widget/recent_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _places = MConstants.places;
  List<String> _suggest;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _clearText() {
    _textEditingController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    final List<RecentSearch> _recent = _publicProv.recentSearches;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              'assets/svg/searchBG.svg',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: CustomTextFieldSearch(
                      controller: _textEditingController,
                      prefixicon: Icons.search_rounded,
                      fillColor: Theme.of(context).hoverColor,
                      iconSize: 26,
                      hint: 'search',
                      onchanged: (String value) {
                        if (value.length >= 1) {
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
                  AutoCompleteTile(
                    clearText: _clearText,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Text(
                      'Around me',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  AroundMeIcons(),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'Recent',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return RecentCard(
                        recentSearch: _recent[index],
                        clearText: _clearText,
                      );
                    },
                    itemCount: _recent.length > 5 ? 5 : _recent.length,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
