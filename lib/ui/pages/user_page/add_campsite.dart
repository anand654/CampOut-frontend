import 'package:flutter/material.dart';
import 'package:me_and_my_tent_client/models/camp/camp_address.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:me_and_my_tent_client/models/camp/camp_prev.dart';
import 'package:me_and_my_tent_client/models/camp/camp_site.dart';
import 'package:me_and_my_tent_client/models/camp/contact_info.dart';
import 'package:me_and_my_tent_client/state_management/campSite/privateProvider.dart';
import '../../widgets/global_widgets/loading_msg.dart';
import '../../widgets/global_widgets/loading_window.dart';
import '../../widgets/user_page_widget/add_campsite_widgets/add_aboutCamp.dart';
import '../../widgets/user_page_widget/add_campsite_widgets/add_accomadation.dart';
import '../../widgets/user_page_widget/add_campsite_widgets/add_contactInfo.dart';
import '../../widgets/user_page_widget/add_campsite_widgets/add_facility.dart';
import '../../widgets/user_page_widget/add_campsite_widgets/add_images.dart';
import '../../widgets/user_page_widget/add_campsite_widgets/add_address.dart';
import '../../widgets/user_page_widget/add_campsite_widgets/add_price.dart';

class AddEditCampSite extends StatefulWidget {
  AddEditCampSite({CampSitePrev campSitePrev, this.newCamp = true})
      : _campSitePrev =
            campSitePrev ?? CampSitePrev(campAddress: CampAddress());
  final CampSitePrev _campSitePrev;
  final bool newCamp;
  @override
  _AddEditCampSiteState createState() => _AddEditCampSiteState();
}

class _AddEditCampSiteState extends State<AddEditCampSite> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Future _fetchCampSite;

  @override
  void initState() {
    super.initState();
    _fetchCampSite = fetchCampSite();
  }

  Future fetchCampSite() async {
    CampSite _campsite;
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    if (widget.newCamp) {
      _campsite = CampSite(contactInfo: ContactInfo());
    } else {
      _campsite =
          await _privateProv.getUserCampSite(widget._campSitePrev.campId);
    }
    _privateProv.initiialCamp(widget._campSitePrev, _campsite);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  'assets/svg/tree.svg',
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: Theme.of(context).cardColor.withOpacity(0.4),
                ),
              ),
              Container(
                child: FutureBuilder<Object>(
                  future: _fetchCampSite,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active) {
                      return LoadingMessage();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SingleChildScrollView(
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              AddImages(),
                              AddAboutCamp(),
                              AddressPicker(),
                              AddCampContactInfo(),
                              AddAccomodation(),
                              AddFacility(),
                              AddPrice(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, top: 10, bottom: 20),
                                  child: ElevatedButton(
                                    onPressed: _saveCamp,
                                    child: Text('save'),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.only(
                                            left: 50,
                                            right: 50,
                                            top: 13,
                                            bottom: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return LoadingMessage();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCamp() async {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      final _dialogue = LoadingWindow(context: context);
      if (_privateProv.imageUrls.length != 0) {
        FocusScope.of(context).unfocus();
        _dialogue.loadingWindow('Saving CampSite');
        final saved = widget.newCamp
            ? await _privateProv.addCampSite()
            : await _privateProv.editCampSite();
        if (saved) {
          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
          _dialogue.showSnackBar('Campsite added successfully', true);
        } else {
          Navigator.pop(context);
          _dialogue.showSnackBar('couldn\'t add campsite', false);
        }
      } else {
        _dialogue.showSnackBar('please add images', false);
      }
    }
  }
}
