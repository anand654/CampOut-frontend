import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../../models/camp/camp_prev.dart';
import '../../../state_management/campSite/privateProvider.dart';
import '../../../state_management/campSite/publicProvider.dart';
import '../../../ui/pages/search_page/description_page.dart';
import '../../../ui/widgets/global_widgets/alert_windows.dart';
import '../../../ui/widgets/global_widgets/loading_window.dart';
import '../../../ui/widgets/global_widgets/rating_bar.dart';

class SavedCard extends StatelessWidget {
  final CampSitePrev savedCampSite;

  const SavedCard({
    @required this.savedCampSite,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> _addressList =
        savedCampSite.campAddress.address.split(',');
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Container(
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  height: 93,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: BlurHash(
                                  hash: MConstants.blurHash,
                                  imageFit: BoxFit.cover,
                                  curve: Curves.easeInOut,
                                  image: savedCampSite.imageUrl,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    savedCampSite.campName,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    savedCampSite.price == '0'
                                        ? 'Open to all'
                                        : '${savedCampSite.price} / day',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  MyRatingBar(
                                    rating: savedCampSite.rating,
                                    color: const Color(0xFF606580),
                                    iconSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                              campSitePrev: savedCampSite,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _deleteFav(context),
                      icon: Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, right: 16),
              child: Text(
                '${_addressList[_addressList.length - 3]} , ${_addressList[_addressList.length - 2]}',
                style: Theme.of(context).textTheme.subtitle2,
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFav(BuildContext context) async {
    final _dialogue = LoadingWindow(context: context);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertWindow(
          content: 'Delete saved Campsite permanently ?',
          deletePressed: () async {
            _dialogue.loadingWindow('Deleting CampSite');
            Provider.of<PublicProvider>(context, listen: false)
                .toggleFavorite(savedCampSite.campId);
            final removed =
                await Provider.of<PrivateProvider>(context, listen: false)
                    .deleteUserFavs(savedCampSite.campPrevId);
            if (removed) {
              Navigator.pop(context);
              _dialogue.showSnackBar('Campsite deleted successfully', true);
            } else {
              Navigator.pop(context);
              _dialogue.showSnackBar('couldn\'t delete campsite', false);
            }
            Navigator.pop(context);
          },
          cancelPressed: () => Navigator.pop(context),
        );
      },
    );
  }
}
