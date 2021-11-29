import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../../models/camp/camp_prev.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/pages/search_page/description_page.dart';
import '../../../ui/widgets/global_widgets/rating_bar.dart';
import '../global_widgets/loading_msg.dart';

class MostFamous extends StatefulWidget {
  const MostFamous({Key key}) : super(key: key);

  @override
  _MostFamousState createState() => _MostFamousState();
}

class _MostFamousState extends State<MostFamous> {
  Future<List<CampSitePrev>> _fetchMostfamous;

  @override
  void initState() {
    super.initState();
    _fetchMostfamous = fetchMostFamous();
  }

  Future<List<CampSitePrev>> fetchMostFamous() async {
    return await Provider.of<PublicProvider>(context, listen: false)
        .fetchMostFamousSites();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.55,
      child: FutureBuilder(
        future: _fetchMostfamous,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return Center(
              child: LoadingMessage(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: LoadingMessage(),
            );
          }
          final List<CampSitePrev> _campPrev = snapshot.data;
          if (_campPrev.isEmpty)
            return Center(
              child: Text(
                'No Campsites near you or\nallow location to search for camps',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            );
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return MostFamousCampCard(
                campSitePrev: _campPrev[index],
              );
            },
            itemCount: _campPrev.length,
          );
        },
      ),
    );
  }
}

class MostFamousCampCard extends StatelessWidget {
  const MostFamousCampCard({
    Key key,
    @required this.campSitePrev,
  }) : super(key: key);
  final CampSitePrev campSitePrev;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: InkWell(
        child: Container(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.78,
                decoration: BoxDecoration(
                  color: Color(0xFFF8FCFF),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BlurHash(
                        hash: MConstants.blurHash,
                        imageFit: BoxFit.cover,
                        curve: Curves.easeInOut,
                        image: campSitePrev.imageUrl,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 16,
                      top: 6,
                      bottom: 4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            campSitePrev.campName,
                            style: Theme.of(context).textTheme.subtitle1,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                          ),
                        ),
                        MyRatingBar(
                          rating: campSitePrev.rating,
                          color: Color(0xFF606580),
                          iconSize: 16,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 16,
                      bottom: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            campSitePrev.campAddress.address,
                            style: Theme.of(context).textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Text(
                          '₹ ${campSitePrev.price} / day',
                          style: Theme.of(context).textTheme.subtitle2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionPage(
              campSitePrev: campSitePrev,
            ),
          ),
        ),
      ),
    );
  }
}
