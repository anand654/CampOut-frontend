import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../constants/constants.dart';
import '../../../models/camp/camp_reviews.dart';
import '../../../state_management/campSite/privateProvider.dart';
import '../../../ui/widgets/global_widgets/alert_windows.dart';
import '../../../ui/widgets/global_widgets/loading_msg.dart';
import '../../../ui/widgets/global_widgets/loading_window.dart';

class UserReviews extends StatefulWidget {
  const UserReviews({Key key}) : super(key: key);

  @override
  State<UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {
  Future getUserReviews;
  @override
  void initState() {
    super.initState();
    getUserReviews = _getReview();
  }

  Future _getReview() async {
    await Provider.of<PrivateProvider>(context, listen: false)
        .getReviewForUser(true);
  }

  @override
  Widget build(BuildContext context) {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
            'My Reviews',
            style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 16),
          ),
        ),
        body: FutureBuilder(
          future: getUserReviews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Align(
                alignment: Alignment.center,
                child: LoadingMessage(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Selector<PrivateProvider, List<CampReviews>>(
                        selector: (context, privateProv) =>
                            privateProv.userReviews,
                        builder: (context, _list, _) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        MConstants.bigborderRadius),
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Theme.of(context).cardColor)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _list[index].reviewedDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).cardColor,
                                          ),
                                          child: IconButton(
                                            onPressed: () => _deleteReview(
                                                context, _list[index].id),
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        _list[index].review,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: _list.length,
                          );
                        },
                      ),
                    ),
                    Selector<PrivateProvider, bool>(
                      selector: (context, publicProv) => publicProv.fnTriggered,
                      builder: (context, fn, _) {
                        return fn
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitThreeBounce(
                                  color: Theme.of(context).cardColor,
                                  size: 30,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _privateProv.hasNext
                                    ? () => _getMore(context)
                                    : () {},
                                child: Text(
                                    _privateProv.hasNext ? 'more' : 'no more'),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              );
            }
            return Align(
              alignment: Alignment.center,
              child: LoadingMessage(),
            );
          },
        ),
      ),
    );
  }

  Future<void> _getMore(BuildContext context) async {
    await Provider.of<PrivateProvider>(context, listen: false)
        .getReviewForUser(false);
  }

  Future<void> _deleteReview(BuildContext context, String reviewid) async {
    final _privateProv = Provider.of<PrivateProvider>(context, listen: false);
    final _dialogue = LoadingWindow(context: context);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertWindow(
          content: 'Delete saved Campsite permanently ?',
          deletePressed: () async {
            _dialogue.loadingWindow('Deleting your review');
            final removed = await _privateProv.removeReview(reviewid);
            if (removed) {
              Navigator.pop(context);
              _dialogue.showSnackBar('Review deleted successfully', true);
            } else {
              Navigator.pop(context);
              _dialogue.showSnackBar('couldn\'t delete your review', false);
            }
            Navigator.pop(context);
          },
          cancelPressed: () => Navigator.pop(context),
        );
      },
    );
  }
}
