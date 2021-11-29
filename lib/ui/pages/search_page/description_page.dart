import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../models/camp/camp_prev.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_about_camp.dart';
import '../../../ui/widgets/description_page_widget/addReview.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_accomadation.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_call_button.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_contact_info.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_facility.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_image_view.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_rating.dart';
import '../../../ui/widgets/description_page_widget/desc_widgets/desc_review.dart';
import '../../../ui/widgets/global_widgets/loading_msg.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({
    Key key,
    @required this.campSitePrev,
  }) : super(key: key);
  final CampSitePrev campSitePrev;

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final ScrollController _scrollController = ScrollController();
  Future _fetchCampSite;

  @override
  void initState() {
    super.initState();
    _fetchCampSite = fetchCampSite();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future fetchCampSite() async {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    await _publicProv.fetchCampSite(widget.campSitePrev.campId);
    _publicProv.setcurrentCampSitePrev = widget.campSitePrev;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF0F1F7),
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
                height: MediaQuery.of(context).size.height - 90,
                child: FutureBuilder<Object>(
                  future: _fetchCampSite,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active) {
                      return LoadingMessage();
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              leadingWidth: 40,
                              expandedHeight:
                                  MediaQuery.of(context).size.height * 0.52,
                              pinned: false,
                              floating: true,
                              elevation: 16,
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
                              title: Text(
                                widget.campSitePrev.campName,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              backgroundColor: Colors.transparent,
                              flexibleSpace: DescImageShow(),
                            )
                          ];
                        },
                        body: Container(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final List<Widget> _descWidgets = [
                                DescRating(),
                                DescAboutCamp(),
                                DescContactInfo(),
                                DescAccomodation(),
                                DescFacility(),
                                DescAddReview(),
                                Divider(
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                  color: Theme.of(context).cardColor,
                                ),
                                DescReviews(),
                              ];
                              return _descWidgets[index];
                            },
                            itemCount: 8,
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
        floatingActionButton: DescButton(
          price: widget.campSitePrev.price,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
