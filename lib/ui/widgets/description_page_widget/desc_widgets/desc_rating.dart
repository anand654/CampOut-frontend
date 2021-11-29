import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../../../services/httpClient/http_client_contract.dart';
import '../../../../state_management/auth/authProvider.dart';
import '../../../../state_management/campSite/privateProvider.dart';
import '../../../../state_management/campSite/publicProvider.dart';
import '../../../../ui/widgets/global_widgets/alert_windows.dart';
import '../../../../ui/widgets/global_widgets/loading_window.dart';
import '../../../../ui/widgets/global_widgets/rating_bar.dart';

class DescRating extends StatelessWidget {
  DescRating({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _campSitePrev =
        Provider.of<PublicProvider>(context, listen: false).currentCampSitePrev;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyRatingBar(
                  rating: _campSitePrev.rating,
                  color: Color(0xFF606580),
                  iconSize: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_campSitePrev.noofReviews} reviews',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _addRating(context),
            child: Text(
              'add rating',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
              padding: MaterialStateProperty.all(
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addRating(BuildContext context) async {
    final _authProv = Provider.of<AuthProvider>(context, listen: false);
    return await showDialog(
      context: context,
      builder: (context) {
        if (_authProv.authState == AuthState.signedOut) {
          return AlertWindow(
            content: 'Your are not logged in, Please login to proceed further',
            isLogin: true,
            deletePressed: () {},
            cancelPressed: () => Navigator.pop(context),
          );
        }
        return RatingDialogue();
      },
    );
  }
}

class RatingDialogue extends StatefulWidget {
  const RatingDialogue({Key key}) : super(key: key);

  @override
  State<RatingDialogue> createState() => _RatingDialogueState();
}

class _RatingDialogueState extends State<RatingDialogue> {
  double _rating;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      child: Container(
        padding:
            const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your review',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 6.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Theme.of(context).primaryColor),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _postRate(context),
              child: Text(
                'post rating',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _postRate(BuildContext context) async {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    final LoadingWindow _loadingWin = LoadingWindow(context: context);
    _loadingWin.loadingWindow('posting your review');
    final removed = await _privateProv.addRating(
        _rating, _publicProv.currentCampSitePrev.campPrevId);
    if (removed == Status.success) {
      Navigator.pop(context);
      _loadingWin.showSnackBar('Your rating saved successfully', true);
    } else if (removed == Status.exist) {
      Navigator.pop(context);
      _loadingWin.showSnackBar('you\'ve already rated this campsite', true);
    } else {
      Navigator.pop(context);
      _loadingWin.showSnackBar('couldn\'t rate this campsite', false);
    }
    Navigator.pop(context);
  }
}
