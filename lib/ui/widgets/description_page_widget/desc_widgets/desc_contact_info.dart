import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../models/camp/camp_site.dart';
import '../../../../state_management/campSite/publicProvider.dart';

class DescContactInfo extends StatelessWidget {
  const DescContactInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CampSite _campsite =
        Provider.of<PublicProvider>(context, listen: false).currentCampSite;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.call),
              const SizedBox(
                width: 10,
              ),
              Text(
                _campsite.contactInfo.phone,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.mail),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  _campsite.contactInfo.email,
                  style: Theme.of(context).textTheme.subtitle2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'mail',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
