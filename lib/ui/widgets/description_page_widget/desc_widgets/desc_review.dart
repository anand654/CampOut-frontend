import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../constants/constants.dart';
import '../../../../models/camp/camp_reviews.dart';
import '../../../../state_management/campSite/publicProvider.dart';

class DescReviews extends StatefulWidget {
  const DescReviews({Key key}) : super(key: key);

  @override
  State<DescReviews> createState() => _DescReviewsState();
}

class _DescReviewsState extends State<DescReviews> {
  Future getReviews;

  @override
  void initState() {
    super.initState();
    getReviews = _getReview();
  }

  Future _getReview() async {
    await Provider.of<PublicProvider>(context, listen: false)
        .fetchCampReviews(true);
  }

  @override
  Widget build(BuildContext context) {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Reviews',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          FutureBuilder(
            future: getReviews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: Theme.of(context).cardColor,
                      size: 30,
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                final List<CampReviews> _review = _publicProv.campReviews;
                if (_review.isEmpty)
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      'No Reviews',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                return Column(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 20, left: 0, right: 0, bottom: 0),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    child: Text(
                                      _review[index].reviewerName[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              fontSize: 18,
                                              color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${_review[index].reviewerName}\n',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        TextSpan(
                                          text: _review[index].reviewedDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _review[index].review,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Theme.of(context).cardColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: _review.length >= 3 ? 3 : _review.length,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CampReviewBottomSheet();
                            },
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent),
                        child: Text(
                          'More reviews',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class CampReviewBottomSheet extends StatelessWidget {
  const CampReviewBottomSheet({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _publicProv = Provider.of<PublicProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MConstants.bigborderRadius),
          topRight: Radius.circular(MConstants.bigborderRadius),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Selector<PublicProvider, List<CampReviews>>(
              selector: (context, publicProv) => publicProv.campReviews,
              builder: (context, _list, _) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(MConstants.bigborderRadius),
                          color: Colors.transparent,
                          border:
                              Border.all(color: Theme.of(context).cardColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Theme.of(context).cardColor,
                                child: Text(
                                  _list[index].reviewerName[0],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          fontSize: 20, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${_list[index].reviewerName} \n',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    TextSpan(
                                      text: _list[index].reviewedDate,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 8, right: 8),
                            child: Text(
                              _list[index].review,
                              style: Theme.of(context).textTheme.bodyText2,
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
          Selector<PublicProvider, bool>(
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
                      onPressed:
                          _publicProv.hasNext ? () => _getMore(context) : () {},
                      child: Text(_publicProv.hasNext
                          ? 'more reviews'
                          : 'no more reviews'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
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

  Future<void> _getMore(BuildContext context) async {
    await Provider.of<PublicProvider>(context, listen: false)
        .fetchCampReviews(false);
  }
}
