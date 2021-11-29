import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/constants.dart';
import '../../../../state_management/campSite/publicProvider.dart';

class DescButton extends StatelessWidget {
  const DescButton({
    Key key,
    @required this.price,
  }) : super(key: key);
  final String price;
  @override
  Widget build(BuildContext context) {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      height: 52,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF0F1F7),
              borderRadius: BorderRadius.circular(MConstants.bigborderRadius),
              border: Border.all(
                width: 1,
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 52,
                width: 210,
                child: ElevatedButton(
                  onPressed: () async {
                    final String _phNo =
                        _publicProv.currentCampSite.contactInfo.phone;
                    if (_phNo == null) return;
                    final url = 'tel:$_phNo';
                    try {
                      await launch(url);
                    } catch (e) {
                      throw 'error $e';
                    }
                  },
                  child: Text('contact campground'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(MConstants.bigborderRadius),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xFF1D3557),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text('$price / day'),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
