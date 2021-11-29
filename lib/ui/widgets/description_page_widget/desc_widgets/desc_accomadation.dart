import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/publicProvider.dart';

class DescAccomodation extends StatelessWidget {
  const DescAccomodation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _accommodation =
        Provider.of<PublicProvider>(context, listen: false)
            .currentCampSite
            .accomadation;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
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
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
            ),
            padding: const EdgeInsets.all(0.0),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Icon(
                    MIcons.accomadation(
                      _accommodation[index],
                    ),
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      _accommodation[index],
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              );
            },
            itemCount: _accommodation.length,
          ),
        ],
      ),
    );
  }
}
