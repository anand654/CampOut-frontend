import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../../constants/constants.dart';
import '../../../models/camp/camp_prev.dart';
import '../../../ui/pages/search_page/description_page.dart';
import '../../../ui/widgets/global_widgets/rating_bar.dart';

class CampListPreview extends StatelessWidget {
  const CampListPreview({
    Key key,
    @required this.campSitePrev,
  }) : super(key: key);
  final CampSitePrev campSitePrev;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
      height: 200,
      child: AspectRatio(
        aspectRatio: 1.8,
        child: InkWell(
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                height: 185,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 200,
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 4, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          MyRatingBar(
                            rating: campSitePrev.rating,
                            color: Colors.white,
                            iconSize: 16,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            campSitePrev.campName,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                          ),
                          Text(
                            campSitePrev.campAddress.address,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Spacer(),
                          Text(
                            '₹ ${campSitePrev.price} / day',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
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
      ),
    );
  }
}
