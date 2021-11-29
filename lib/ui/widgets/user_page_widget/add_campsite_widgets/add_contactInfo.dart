import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/privateProvider.dart';
import '../../../../ui/widgets/user_page_widget/custom_textFormField.dart';

class AddCampContactInfo extends StatelessWidget {
  const AddCampContactInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
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
            'Contact Information',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            initialvalue:
                _privateProv.editedUserCampSite.contactInfo.phone ?? '',
            hint: 'Phone Number',
            onsaved: (String value) => _privateProv.setPhoneNo = value,
            isprice: true,
            validator: (value) {
              if (value.isEmpty) return 'please enter phone number';
              if (value.length != 10) return 'phone number shoulb be 10 digit';
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  initialvalue:
                      _privateProv.editedUserCampSite.contactInfo.email ?? '',
                  hint: 'Contact Email',
                  onsaved: (String value) => _privateProv.setEmail = value,
                  validator: (value) {
                    if (value.isEmpty) return 'please enter email address';
                    if (!isEmail(value)) return 'enter an valid email address';
                    return null;
                  },
                ),
              ),
              Text('mail'),
            ],
          ),
        ],
      ),
    );
  }
}
