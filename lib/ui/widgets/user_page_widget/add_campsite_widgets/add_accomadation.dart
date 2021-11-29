import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/privateProvider.dart';

class AddAccomodation extends StatelessWidget {
  const AddAccomodation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
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
            'Accomodations',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          AccomadateSelect(),
        ],
      ),
    );
  }
}

class AccomadateSelect extends StatelessWidget {
  final List<String> _accomadate = MIcons.accomadationList;
  @override
  Widget build(BuildContext context) {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    return Container(
      child: Selector<PrivateProvider, List<String>>(
        selector: (context, privateProv) => privateProv.accomadation,
        shouldRebuild: (pre, next) => pre != next,
        builder: (context, _list, _) {
          return Wrap(
            children: List.generate(
              _accomadate.length,
              (index) {
                return InkWell(
                  child: Card(
                    shape: StadiumBorder(),
                    color: _list.contains(_accomadate[index])
                        ? Theme.of(context).cardColor
                        : Theme.of(context).hoverColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 12, right: 12),
                      child: Text(
                        _accomadate[index],
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    elevation: 0.0,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () =>
                      _privateProv.selectAccomadation = _accomadate[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
