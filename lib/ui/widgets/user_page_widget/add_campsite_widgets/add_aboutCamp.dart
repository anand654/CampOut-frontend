import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/privateProvider.dart';
import '../../../../ui/widgets/user_page_widget/custom_textFormField.dart';

class AddAboutCamp extends StatelessWidget {
  const AddAboutCamp({
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
            'About Campground',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).cardColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      initialvalue: _privateProv.editedUserCampSite.about ?? '',
                      hint: 'About',
                      onsaved: (String value) => _privateProv.setAbout = value,
                      validator: (value) {
                        if (value.isEmpty) return 'please enter about camp';
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      initialvalue:
                          _privateProv.editedUserCampSitePrev.campName ?? '',
                      hint: 'Camp Name',
                      onsaved: (String value) =>
                          _privateProv.setCampName = value,
                      validator: (value) {
                        if (value.isEmpty)
                          return 'please enter name of the camp';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Camp Type',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          CampTypeSelect(),
        ],
      ),
    );
  }
}

class CampTypeSelect extends StatelessWidget {
  final List<String> _campType = MIcons.campType;
  @override
  Widget build(BuildContext context) {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    return Container(
      child: Selector<PrivateProvider, String>(
        selector: (context, privateProv) => privateProv.campType,
        shouldRebuild: (pre, next) => pre != next,
        builder: (context, _type, _) {
          return Wrap(
            children: List.generate(
              _campType.length,
              (index) {
                return InkWell(
                  child: Card(
                    shape: StadiumBorder(),
                    color: _type ==
                            _campType[index].replaceAll(' ', '').toLowerCase()
                        ? Theme.of(context).cardColor
                        : Theme.of(context).hoverColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 12, right: 12),
                      child: Text(
                        _campType[index],
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    elevation: 0.0,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => _privateProv.selectcampType = _campType[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
