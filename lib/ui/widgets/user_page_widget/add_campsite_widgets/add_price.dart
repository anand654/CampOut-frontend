import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/privateProvider.dart';
import '../../../../ui/widgets/user_page_widget/custom_textFormField.dart';

class AddPrice extends StatelessWidget {
  const AddPrice({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      height: 52,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
              border: Border.all(width: 1, color: Theme.of(context).cardColor),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                height: 52,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(MConstants.bigborderRadius),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    'contact campground',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: CustomTextFormField(
                    initialvalue:
                        _privateProv.editedUserCampSitePrev.price ?? '',
                    isprice: true,
                    hint: 'price',
                    onsaved: (String value) => _privateProv.setPrice = value,
                    validator: (value) {
                      if (value.isEmpty) return 'please provide price';
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  '₹/day',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
