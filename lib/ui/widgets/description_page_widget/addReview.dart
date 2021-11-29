import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../models/camp/camp_reviews.dart';
import '../../../../services/httpClient/http_client_contract.dart';
import '../../../../state_management/auth/authProvider.dart';
import '../../../../state_management/campSite/privateProvider.dart';
import '../../../../state_management/campSite/publicProvider.dart';
import '../../../../ui/widgets/global_widgets/alert_windows.dart';
import '../../../../ui/widgets/global_widgets/loading_window.dart';

class DescAddReview extends StatelessWidget {
  const DescAddReview({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: InkWell(
        child: Stack(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Theme.of(context).cardColor,
                ),
                borderRadius: BorderRadius.circular(
                  MConstants.bigborderRadius,
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text('write review'),
                Spacer(),
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                      MConstants.bigborderRadius,
                    ),
                  ),
                  child: Text(
                    'add review',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _addReview(context),
      ),
    );
  }

  Future<void> _addReview(BuildContext context) async {
    final _authProv = Provider.of<AuthProvider>(context, listen: false);
    if (_authProv.authState == AuthState.signedOut) {
      return await showDialog(
        context: context,
        builder: (context) {
          return AlertWindow(
            content: 'Your are not logged in, Please login to proceed further',
            isLogin: true,
            deletePressed: () {},
            cancelPressed: () => Navigator.pop(context),
          );
        },
      );
    }
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddReviewBottomSheet();
      },
      isScrollControlled: true,
    );
  }
}

class AddReviewBottomSheet extends StatefulWidget {
  AddReviewBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  double _rating;
  bool _error = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Rate Camp',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Container(
            child: RatingBar.builder(
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
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your review',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(top: 10, left: 20, right: 20),
                filled: true,
                hintText: 'your review',
                fillColor: Theme.of(context).hoverColor,
                focusColor: Theme.of(context).hoverColor,
                errorText: _error ? 'review can\'t be empty' : null,
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MConstants.bigborderRadius),
                  borderSide: BorderSide(color: Theme.of(context).hoverColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MConstants.bigborderRadius),
                  borderSide: BorderSide(color: Theme.of(context).hoverColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MConstants.bigborderRadius),
                  borderSide: BorderSide(color: Theme.of(context).hoverColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MConstants.bigborderRadius),
                  borderSide: BorderSide(color: Theme.of(context).hoverColor),
                ),
              ),
              style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.black,
                  height: 2,
                  fontWeight: FontWeight.w500),
              maxLength: 200,
              maxLines: 6,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => _postReview(context),
              child: Text(
                'Post my review',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          )
        ],
      ),
    );
  }

  Future<void> _postReview(BuildContext context) async {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    final LoadingWindow _loadingWin = LoadingWindow(context: context);
    if (_controller.text.isEmpty) {
      setState(() {
        _error = true;
      });
    } else {
      FocusScope.of(context).unfocus();
      _loadingWin.loadingWindow('posting your review');
      final removed = await _privateProv.addReview(
        CampReviews(
          campPrevId: _publicProv.currentCampSitePrev.campPrevId,
          reviewedDate: DateFormat('EEE, M/d/y').format(DateTime.now()),
          review: _controller.text,
        ),
        _rating,
      );
      if (removed == Status.success) {
        Navigator.pop(context);
        _loadingWin.showSnackBar('Review posted successfully', true);
      } else if (removed == Status.exist) {
        Navigator.pop(context);
        _loadingWin.showSnackBar('you\'ve already reviewd this campsite', true);
      } else {
        Navigator.pop(context);
        _loadingWin.showSnackBar('couldn\'t post review', false);
      }
      Navigator.pop(context);
    }
  }
}
